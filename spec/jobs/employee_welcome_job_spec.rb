require "rails_helper"

RSpec.describe EmployeeWelcomeJob, type: :job do
  let!(:department) { Department.create!(name: "Engineering") }

  let!(:employee) do
    Employee.create!(
      name: "John",
      email: "john@example.com",
      salary: 50000,
      department: department
    )
  end

  it "processes the employee successfully" do
    expect {
      described_class.perform_now(employee.id)
    }.not_to raise_error
  end
end