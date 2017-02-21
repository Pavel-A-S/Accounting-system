class ExpendituresController < ApplicationController
  before_action :set_expenditure, only: [:show, :edit, :update, :destroy]
  before_action :check_editors, except: [:show, :index]
  before_action :check_viewers, only: [:show, :index]

  def index
    @expenditures = Expenditure.all
  end

  def show
  end

  def new
    @expenditure = Expenditure.new
  end

  def edit
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)
    if @expenditure.save
      flash[:notice] = t(:expenditure_was_created)
      redirect_to @expenditure
    else
      render :new
    end
  end

  def update
    if @expenditure.update(expenditure_params)
      flash[:notice] = t(:expenditure_was_updated)
      redirect_to @expenditure
    else
      render :edit
    end
  end

  def destroy
    if @expenditure.destroy
      flash[:notice] = t(:expenditure_was_deleted)
      redirect_to expenditures_path
    else
      flash[:notice] = t(:expenditure_was_not_deleted)
      redirect_to root_path
    end
  end

  private
    def set_expenditure
      @expenditure = Expenditure.find(params[:id])
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

    def expenditure_params
      params.require(:expenditure).permit(:name, :description)
    end
end
