module Api
  module V1
    class ChatsController < ApplicationController
      def index
        application = Application.find_by_token(params[:application_token])
        @chats = Chat.find_by_application_id(application.id)
        if @chats
          render json: {data: @chats},status: :ok
        else
          render json: "Unsuccessful: no chats of the following token", status: :not_found
        end
      end

      def show
        @chat = Chat.find_by_number(params[:chat_number])
        if @chat
          render json: {data: @chat},status: :ok
        else
          render json: "Unsuccessful: no @chat with the following Number", status: :not_found
        end
      end

      def create

         ChatJob.perform_async(params[:application_token])
         render json: "Chat Creation in progress",status: :ok
      end

      def destroy
        @application = Application.find_by_token(params[:application_token])
        @chat = Chat.find_by(application_id: @application.id, number: params[:chat_number])
        if @chat.destroy
          render json:"chat deleted Successfully",status: :ok
        else
          render json: @chat.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
