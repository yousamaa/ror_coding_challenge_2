class User < ApplicationRecord
  has_many :task_assignments, dependent: :destroy
  has_many :tasks, through: :task_assignments
end
