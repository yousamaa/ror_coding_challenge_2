class Api::TasksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_task, only: %i[update destroy assign progress]

  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      if @task.status_was != 'completed' && @task.status_changed? && @task.status == 'completed'
        @task.completed_at = Time.current
      end

      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      render json: "Task deleted"
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def index
    @tasks = Task.all

    render json: @tasks
  end

  def assign
    if params[:user_id].present?
      user = User.find_by_id(params[:user_id])
      if user.present?
        @task.user_id = user.id
        render json: "Task assigned to user"
      else
        render json: "user record not found"
      end
    else
      render json: "Param missing user_id"
    end
  end

  def progress
    if params[:progress].present?
      @task.progress = params[:progress]

      render json: "Progress Updated"
    else
      render json: "Param missing progress"
    end
  end

  def overdue
    @overdue_tasks = Task.overdue
    render json: @overdue_tasks
  end

  def status
    if params[:status].present?
      @tasks_by_status = Task.by_status(status)
      render json: @tasks_by_status
    else
      render json: "Param missing status"
    end
  end

  def completed
    if params[:startDate].present? && params[:endDate].present?
      @completed_tasks = Task.completed_within_date_range(Date.parse(params[:startDate]), Date.parse(params[:endDate]))
      render json: @completed_tasks
    else
      render json: "Param missing startDate" unless params[:startDate].present?
      render json: "Param missing endDate" unless params[:endDate].present?
      render json: "Params missing startDate and endDate" unless params[:startDate].present? && params[:endDate].present?
    end
  end

  def statistics
    total_tasks = Task.count
    completed_tasks = Task.by_status('completed').count
    percentage_completed = total_tasks > 0 ? (completed_tasks.to_f / total_tasks * 100).round(2) : 0

    render json: {
      total_tasks: total_tasks,
      completed_tasks: completed_tasks,
      percentage_completed: percentage_completed
    }
  end

  def priority_queue
    @tasks_by_priority = Task.priority_queue
    render json: @tasks_by_priority
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.permit(:title, :description, :status, :priority, :progress, :due_at, :started_at, :completed_at)
  end
end
