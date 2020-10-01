class PrototypesController < ApplicationController
  before_action :authenticate_user!, except:[:index,:show]
  before_action :set_prototype, only: [:edit, :show]
  before_action :move_to_index, only: [:edit]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def update
    @prototype = Prototype.find(params[:id])
      if @prototype.update(prototype_params)
        redirect_to prototype_path(params[:id])
      else
        render :edit
      end
      # Issue:1 データを変えていないときは更新していないに含まれるのか？
  end

  def edit
  end

  def destroy
    prototypes = Prototype.find(params[:id])
    prototypes.destroy
    redirect_to root_path
  end

  private

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def prototype_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in? && current_user.id ==  @prototype.user.id
      redirect_to action: :index
    end
  end

end