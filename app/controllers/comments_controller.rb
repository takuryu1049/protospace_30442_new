class CommentsController < ApplicationController
  before_action :set_prototype, only: [:create]
  before_action :authenticate_user!

  def create
    @comment = Comment.new(params_comment) 
    if @comment.save
      @comments = @prototype.comments.includes(:user)
      redirect_to prototype_path(params[:prototype_id])
    else
      @comments = @prototype.comments.includes(:user)
      render "/prototypes/show"
    end
  end

  private

  def set_prototype
    @prototype = Prototype.find(params[:prototype_id])
  end

  def params_comment
    params.require(:comment).permit(:text).merge(user_id: current_user.id,prototype_id: params[:prototype_id])
  end

end
