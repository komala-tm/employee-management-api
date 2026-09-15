require "rails_helper"

RSpec.describe Employee, type: :model do
  let(:department) { Department.create!(name: "Engineering") }

  it "is valid with valid attributes" do
    employee = Employee.new(
      name: "John",
      email: "john@example.com",
      salary: 50000,
      department: department
    )

    expect(employee).to be_valid
  end

  it "requires an email" do
    employee = Employee.new(
      name: "John",
      salary: 50000,
      department: department
    )

    expect(employee).not_to be_valid
  end
end