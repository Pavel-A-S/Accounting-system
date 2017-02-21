class OrdersController < ApplicationController
  include OrdersHelper

  before_action :set_order, only: [:show, :edit, :update]

  def download_file
    if @file = OrderFile.find_by('id = ?', params[:id]) # ok
      @order = @file.order
      if @order && can_he_see?(@order)
        path = @file.path
        send_file Rails.root.to_s + path, x_sendfile: true if path
      else
        flash[:alert] = t(:no_file)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:no_file)
      redirect_to root_path
    end
  end

  def delete_file
    if @file = OrderFile.find_by('id = ?', params[:id]) # ok
      @order = @file.order
      if can_he_edit?(@order) && @file.destroy
        flash[:notice] = t(:file_was_deleted)
        redirect_to edit_order_path(@order.id)
      else
        flash[:notice] = t(:file_was_not_deleted)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:no_file)
      redirect_to root_path
    end
  end

  def index
    @title = t(:current_orders)
    @state1 = Order.states[:executed]
    @state2 = Order.states[:canceled]
    @state3 = Order.states[:approval]
    if current_user.user?
      @orders_part_1 = current_user.permitted_orders.where
                                   .not("state = ? or state = ?", @state1,
                                                                  @state2)
      @orders_part_2 = current_user.orders.where.not("state = ? or state = ?",
                                                     @state1,
                                                     @state2)
      @orders = @orders_part_1 + @orders_part_2
    elsif current_user.cfo? && !cfo_treasurer_case?
      @orders_part_1 = current_user.permitted_orders.where
                                   .not("state = ? or state = ? or state = ?",
                                        @state1,
                                        @state2,
                                        @state3)
      @orders_part_2 = current_user.orders.where
                                   .not("state = ? or state = ? or state = ?",
                                        @state1,
                                        @state2,
                                        @state3)
      @orders_part_3 = Order.where("state = ?", @state3)

      @orders = @orders_part_1 + @orders_part_2 + @orders_part_3
    elsif cfo_treasurer_case?
      @orders = Order.where.not("state = ? or state = ?", @state1, @state2)
    elsif current_user.auditor?
      @orders = Order.where.not("state = ? or state = ?", @state1, @state2)
    elsif current_user.admin?
      @orders = []
    end
  end

  def canceled
    @title = t(:canceled_orders)
    @state = Order.states[:canceled]
    if current_user.user? || (current_user.cfo? && !cfo_treasurer_case?)
      @orders_part_1 = current_user.permitted_orders.where(state: @state)
      @orders_part_2 = current_user.orders.where(state: @state)
      @orders = @orders_part_1 + @orders_part_2
    elsif cfo_treasurer_case?
      @orders = Order.where(state: @state)
    elsif current_user.auditor?
      @orders = Order.where(state: @state)
    elsif current_user.admin?
      @orders = []
    end
    render 'orders/index'
  end

  def executed
    @title = t(:executed_orders)
    @state = Order.states[:executed]
    if current_user.user? || (current_user.cfo? && !cfo_treasurer_case?)
      @orders_part_1 = current_user.permitted_orders.where(state: @state)
      @orders_part_2 = current_user.orders.where(state: @state)
      @orders = @orders_part_1 + @orders_part_2
    elsif cfo_treasurer_case?
      @orders = Order.where(state: @state)
    elsif current_user.auditor?
      @orders = Order.where(state: @state)
    elsif current_user.admin?
      @orders = []
    end
    render 'orders/index'
  end

  def show
    if can_he_see?(@order)
      render 'show'
    else
      flash[:error] = t(:not_allowed)
      redirect_to orders_path
    end
  end

  def new
    @order = Order.new user: current_user
  end

  def edit
    if can_he_edit?(@order)
      render 'edit'
    else
      flash[:error] = t(:not_allowed)
      redirect_to orders_path
    end
  end

  def create
    if !current_user.admin?
      @order = Order.new(order_params)
      @order.user = current_user
      @order.state = 'preparation'

      if @order.save
        files = params[:order][:files]
        dir = "private/files/orders/order_#{@order.id}/"
        handle_files(@order, :order_files, files, dir) if files
        flash[:notice] = t(:order_was_created)
        redirect_to @order
      else
        render :new
      end
    else
      redirect_to root_path
    end
  end

  def update
    # Users can change order states
    if params[:commit] && params[:order] && !params[:order][:state].blank?
      newstate = params[:order][:state]
      verificator_id = params[:order][:user]
      note = params[:order][:note]

      result = @order.changestate(newstate, current_user.id, verificator_id,
                                                             note)
      if !result.blank?
        flash[:error] = result
      else
        flash[:message] = t(:state_was_changed)
      end
      redirect_to orders_path and return
      # redirect_to :back and return
    end

    # Treasurer can add order to journal
    if params[:to_journal] && cfo_treasurer_case?
      if @order = Order.find_by(id: params[:to_journal])
        @order.send_to_journal
        flash[:notice] = t(:order_was_sent)
        redirect_to executed_orders_path and return
      end
    end

    # Order owner can withdraw it in verification state
    if params[:withdraw]
      if @order = Order.find_by(id: params[:withdraw])
        if @order.author?(current_user.id) && @order.withdraw
          flash[:notice] = t(:order_was_withdrawn)
          redirect_to orders_path and return
        end
      end
    end

    # Order owner can update his order in 'preparation' state
    if params[:order] && can_he_edit_as_author?(@order)
      if @order.update(order_params)
        files = params[:order][:files]
        dir = "private/files/orders/order_#{@order.id}/"
        handle_files(@order, :order_files, files, dir) if files
        flash[:notice] = t(:order_was_updated)
        redirect_to @order
      else
        render :edit
      end

    # CFO and Treasurer can update specific parts of orders
    # (project_id, ccy, amount) in 'approval', 'execution' and 'executed' states
    elsif params[:order] && special_access_for_cfo_or_treasurer?(@order.state)
      @order.project_id = params[:order][:project_id]
      @order.expenditure_id = params[:order][:expenditure_id]
      @order.ccy = params[:order][:ccy]
      @order.amount = params[:order][:amount]
      @order.handled = params[:order][:handled]
      if @order.save
        @order.log_it(current_user.id)
        files = params[:order][:files]
        dir = "private/files/orders/order_#{@order.id}/"
        handle_files(@order, :order_files, files, dir) if files
        flash[:notice] = t(:order_was_updated)
        redirect_to @order
      else
        render :edit
      end
    else
      flash[:error] = t(:not_allowed)
      redirect_to root_path
    end
  end

  def destroy
    if 1 == 2
      @order.destroy
      flash[:notice] = t(:order_was_deleted)
    end
    redirect_to orders_path
  end

  private
    def set_order
      if !(@order = Order.find_by(id: params[:id]))
        redirect_to orders_path
      end
    end

    def order_params
      params.require(:order).permit(:subject, :amount, :ccy, :expenditure_id,
                                                             :project_id,
                                                             :files)
    end
end
