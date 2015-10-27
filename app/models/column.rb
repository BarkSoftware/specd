class Column < ActiveRecord::Base
  belongs_to :project
  has_many :issues
  scope :todo, -> { where(todo: true) }
  scope :in_progress, -> { where(in_progress: true) }
  scope :closed, -> { where(closed: true) }
  scope :parking_lot, -> { where(issues_start_here: true) }
end
