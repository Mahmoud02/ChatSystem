module Api
  module V1
    class ApplicationsController < ApplicationController
      def index
        @applications = Application.all
        render json: {data:@applications},status: :ok
      end

      def show
        application = Application.find_by_token(params[:token])
        if application
          render json: {data: application},status: :ok
        else
          render json: "Unsuccessful: no Application with the following token", status: :not_found
        end
      end

      def create
        @name = params[:name]
        @new_token = SecureRandom.uuid
        @application = Application.create({ name: @name, token: @new_token })
        if @application.save
          render json:"application created Successfully",status: :created
        else
          render json: @application.errors, status: :unprocessable_entity
        end
      end
      def update
        @application = Application.find_by_token(params[:token])
        if @application.update_attributes(app_params)
          render json:"application updated Successfully",status: :ok
        else
          render json: @application.errors, status: :unprocessable_entity
        end

      end
      def destroy
        @application = Application.find_by_token(params[:token])

        if @application.destroy
          render json:"application deleted Successfully",status: :ok
        else
          render json: @application.errors, status: :unprocessable_entity
        end
      end
      private
      def app_params
        params.permit(:name)
      end
    end
  end
end
