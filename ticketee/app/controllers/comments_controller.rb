class CommentsController < ApplicationController
  before_action :set_ticket

  def create
    @creator = CommentCreator.build(@ticket.comments, current_user,
      sanitized_parameters)
    authorize @creator.comment, :create?

    if @creator.save
      flash[:notice] = "Comment has been created."
      redirect_to [@ticket.project, @ticket]
    else
      flash.now[:alert] = "Comment has not been created."
      @project = @ticket.project
      @comment = @creator.comment
      render "tickets/show"
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def comment_params
    params.require(:comment).permit(:text, :state_id, :tag_names)
  end

  def sanitized_parameters
    whitelisted_params = comment_params

    unless policy(@ticket).change_state?
      whitelisted_params.delete(:state_id)
    end

    unless policy(@ticket).tag?
      whitelisted_params.delete(:tag_names)
    end

    whitelisted_params
  end
end
