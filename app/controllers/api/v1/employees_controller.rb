class Api::V1::EmployeesController < ApplicationController
  def index
    render json: Employee.all
  end

  def show
    render json: Employee.find(params[:id])
  end

  def create
  employee = Employee.new(employee_params)

  if employee.save
    EmployeeWelcomeJob.perform_later(employee.id)

    render json: employee, status: :created
  else
    render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
  end
end

  def update
    employee = Employee.find(params[:id])

    if employee.update(employee_params)
      render json: employee
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Employee.find(params[:id]).destroy
    head :no_content
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :email, :salary, :department_id)
  end
end