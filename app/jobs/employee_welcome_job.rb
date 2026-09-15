class EmployeeWelcomeJob < ApplicationJob
  queue_as :default

  def perform(employee_id)
    employee = Employee.find(employee_id)

    Rails.logger.info "Welcome email would be sent to #{employee.email}"
  end
end