class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  def search
    authorize @project, :show?
    if params[:search].present?
      @tickets = @project.tickets.search(params[:search])
    else
      @tickets = @project.tickets
    end
    render "projects/show"
  end

  def new
    @ticket = @project.tickets.build
    authorize @ticket, :create?
    @ticket.attachments.build
  end

  def create
    @ticket = @project.tickets.new

    whitelisted_params = ticket_params
    unless policy(@ticket).tag?
      whitelisted_params.delete(:tag_names)
    end

    @ticket.attributes = whitelisted_params
    @ticket.author = current_user
    authorize @ticket, :create?

    if @ticket.save
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      flash.now[:alert] = "Ticket has not been created."
      render "new"
    end
  end

  def show
    authorize @ticket, :show?
    @comment = @ticket.comments.build(state_id: @ticket.state_id)
  end

  def edit
    authorize @ticket, :update?
  end

  def update
    authorize @ticket, :update?
    if @ticket.update(ticket_params)
      flash[:notice] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      flash.now[:alert] = "Ticket has not been updated."
      render "edit"
    end
  end

  def destroy
    authorize @ticket, :destroy?
    @ticket.destroy
    flash[:notice] = "Ticket has been deleted."

    redirect_to @project
  end

  private

  def ticket_params
    params.require(:ticket).permit(:name, :description, :tag_names,
      attachments_attributes: [:file, :file_cache])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end
end
