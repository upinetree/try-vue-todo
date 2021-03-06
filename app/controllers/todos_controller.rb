class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { @todos = Todo.all.order(id: :asc) }
    end
  end

  def show
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      redirect_to @todo
    else
      render json: { errors: @todo.errors.full_messages }
    end
  end

  def update
    if @todo.update(todo_params)
      redirect_to @todo
    else
      render json: { errors: @todo.errors.full_messages }
    end
  end

  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title)
  end
end
