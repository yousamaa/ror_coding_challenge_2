class Task < ApplicationRecord
  has_many :task_assignments, dependent: :destroy
  has_many :users, through: :task_assignments

  enum status: { not_assigned: 'not_assigned', completed: 'completed', in_progress: 'in_progress' }
  enum priority: { low: 'low', medium: 'medium', high: 'high' }

  validates :title, :description, :due_at, presence: true
end
