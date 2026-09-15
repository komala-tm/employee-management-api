class Api::V1::DepartmentsController < ApplicationController
  def index
    render json: Department.all
  end

  def show
    render json: Department.find(params[:id])
  end

  def create
    department = Department.new(department_params)

    if department.save
      render json: department, status: :created
    else
      render json: { errors: department.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    department = Department.find(params[:id])

    if department.update(department_params)
      render json: department
    else
      render json: { errors: department.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Department.find(params[:id]).destroy
    head :no_content
  end

  private

  def department_params
    params.require(:department).permit(:name)
  end
end