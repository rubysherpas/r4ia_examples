class CommentCreator
  attr_reader :comment

  def self.build(scope, current_user, comment_params)
   comment = scope.build(comment_params)
   comment.author = current_user

   new(comment)
  end

  def initialize(comment)
    @comment = comment
  end

  def save
    if @comment.save
      notify_watchers
    end
  end

  def notify_watchers
    (@comment.ticket.watchers - [@comment.author]).each do |user|
      CommentNotifier.created(@comment, user).deliver_now
    end
  end
end
