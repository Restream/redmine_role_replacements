class RoleReplacementsController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id
  before_filter :authorize

  def index
    @role_replacements = @project.role_replacements
  end

  def new
    @role_replacement = @project.role_replacements.build
  end

  def create
    @role_replacement = @project.role_replacements.build(params[:role_replacement])
    if @role_replacement.save
      redirect_to project_role_replacements_url(@project),
          :notice => l(:message_role_replacements_created)
    else
      render :action => "new"
    end
  end

  def edit
    @role_replacement = @project.role_replacements.find(params[:id])
  end

  def update
    @role_replacement = @project.role_replacements.find(params[:id])
    if @role_replacement.update_attributes(params[:role_replacement])
      redirect_to project_role_replacements_url(@project),
          :notice => l(:message_role_replacements_updated)
    else
      render :action => "edit"
    end
  end

  def destroy
    @role_replacement = @project.role_replacements.find(params[:id])
    if @role_replacement.destroy
      flash[:notice] = l(:message_role_replacements_destroyed)
    else
      flash[:alert] = l(:message_role_replacements_not_destroyed)
    end
    redirect_to project_role_replacements_url(@project)
  end
end
