class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]
  before_action :check_editors, except: [:show, :index]
  before_action :check_viewers, only: [:show, :index]

  def index
    @incomes = Income.all
  end

  def show
  end

  def new
    @income = Income.new
  end

  def edit
  end

  def create
    @income = Income.new(income_params)
    if @income.save
      flash[:notice] = t(:income_source_was_created)
      redirect_to @income
    else
      render :new
    end
  end

  def update
    if @income.update(income_params)
      flash[:notice] = t(:income_source_was_updated)
      redirect_to @income
    else
      render :edit
    end
  end

  def destroy
    if @income.destroy
      flash[:notice] = t(:income_source_was_deleted)
      redirect_to incomes_path
    else
      flash[:notice] = t(:income_source_was_not_deleted)
      redirect_to root_path
    end
  end

  private
    def set_income
      @income = Income.find(params[:id])
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

    def income_params
      params.require(:income).permit(:name, :project_id, :description)
    end
end
