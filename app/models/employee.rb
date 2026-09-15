class Employee < ApplicationRecord
  belongs_to :department

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }
end