class Task < ApplicationRecord
  has_many :task_assignments, dependent: :destroy
  has_many :users, through: :task_assignments

  enum status: { not_assigned: 'not_assigned', completed: 'completed', in_progress: 'in_progress' }
  enum priority: { low: 0, medium: 1, high: 2 }

  validates :title, :description, :due_at, presence: true

  scope :overdue, -> { where('due_date < ?', Date.today) }
  scope :by_status, -> (status) { where(status: status) }
  scope :completed_within_date_range, ->(start_date, end_date) {
    where(status: 'completed')
      .where(completed_at: start_date..end_date)
  }
  scope :priority_queue, -> { order(priority: :desc, due_date: :asc) }
end
