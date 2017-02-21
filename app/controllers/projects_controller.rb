class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :check_editors, except: [:show, :index]
  before_action :check_viewers, only: [:show, :index]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:notice] = t(:project_was_created)
      redirect_to @project
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      flash[:notice] = t(:project_was_updated)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = t(:project_was_deleted)
      redirect_to projects_path
    else
      flash[:notice] = t(:project_was_not_deleted)
      redirect_to root_path
    end
  end

  private
    def set_project
      @project = Project.find(params[:id])
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

    def project_params
      params.require(:project).permit(:name, :description)
    end
end
