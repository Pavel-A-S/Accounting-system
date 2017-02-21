class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  before_action :check_editors, except: [:show, :index, :download_file]
  before_action :check_viewers, only: [:show, :index, :download_file]

  def download_file
    if @file = RecordFile.find_by('id = ?', params[:id]) # ok
      @record = @file.record
      if @record
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
    if @file = RecordFile.find_by('id = ?', params[:id]) # ok
      @record = @file.record
      if @file.destroy
        flash[:notice] = t(:file_was_deleted)
        redirect_to edit_record_path(@record.id)
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
    if !params[:date].blank?
      begin
        @date = DateTime.new(params[:date][:year].to_i,
                             params[:date][:month].to_i,
                             params[:date][:day].to_i, 0, 0, 0,
                             Time.now.zone.to_s)
      rescue
        @date = DateTime.now
      end
    else
      @date = DateTime.now
    end

    @records = Record.all
    @balances = []
    @usd_balance = get_balance('USD', @date) and @balances << @usd_balance
    @eur_balance = get_balance('EUR', @date) and @balances << @eur_balance
    @chf_balance = get_balance('CHF', @date) and @balances << @chf_balance
    @rub_balance = get_balance('RUR', @date) and @balances << @rub_balance
  end

  def show
  end

  def new
    @record = Record.new
  end

  def edit
    @record.date = @record.date + @record.date.localtime.utc_offset
  end

  def create
    @record = Record.new(record_params)
    if !@record.exchange? && @record.save
      files = params[:record][:files]
      dir = "private/files/records/record_#{@record.id}/"
      handle_files(@record, :record_files, files, dir) if files
      flash[:notice] = t(:record_was_created)
      redirect_to @record
    else
      render :new
    end
  end

  def update
    if !@record.exchange?
      new_params = record_params
      new_params[:project_id] = nil if new_params[:project_id].blank?
      new_params[:expenditure_id] = nil if new_params[:expenditure_id].blank?
      new_params[:user_id] = nil if new_params[:user_id].blank?
      if @record.update(new_params)
        files = params[:record][:files]
        dir = "private/files/records/record_#{@record.id}/"
        handle_files(@record, :record_files, files, dir) if files
        flash[:notice] = t(:record_was_updated)
        redirect_to @record
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def destroy
    if !@record.exchange? && @record.destroy
      flash[:notice] = t(:record_was_deleted)
      redirect_to records_path
    else
      flash[:notice] = t(:record_was_not_deleted)
      redirect_to root_path
    end
  end

  private
    def set_record
      @record = Record.find(params[:id])
    end

    def check_editors
      if !cfo_treasurer_case?
        flash[:error] = t(:not_allowed)
        redirect_to root_path
      end
    end

    def check_viewers
      if !can_see_as_auditor_cfo_treasurer?
        flash[:error] = t(:not_allowed)
        redirect_to root_path
      end
    end

    def record_params
      params.require(:record).permit(:source_id, :project_id, :expenditure_id,
                                                              :user_id,
                                                              :date,
                                                              :amount,
                                                              :record_type,
                                                              :description,
                                                              :ccy,
                                                              :files)
    end

    def get_balance(type, date)
      expenditures = Record.send(type)
                           .where("amount < ? AND date < ?", 0, date + 1.day)
                           .sum(:amount)

      incomes = Record.send(type)
                      .where("amount >= ? AND date < ?", 0, date + 1.day)
                      .sum(:amount)

      if !(incomes == 0 && expenditures == 0)
        balance = incomes + expenditures
      { expenditure: expenditures, income: incomes, balance: balance,
                                                    type: type }
      else
        return nil
      end
    end
end
