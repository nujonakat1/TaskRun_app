class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :show]

  def index
    @q = current_user.tasks.ransack(params[:q])
    # @tasks = current_user.tasks.order(created_at: :asc)
    @tasks = @q.result(distinct:true)
  end

  def show
    
  end

  def new
    @task = Task.new
  end

  def edit
    
  end


  def update
    
    if @task.update(task_params)
      redirect_to @task, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end

  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  private
		
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task 
    @task = current_user.tasks.find(params[:id])
  end

end
