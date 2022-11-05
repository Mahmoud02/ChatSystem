module Api
  module V1
    class MessagesController < ApplicationController
      def index
        searchByQuery = params[:q]
        if searchByQuery
          search_results = Message.search(searchByQuery)
          render json: search_results, status: :ok

        else
          application = Application.find_by_token(params[:application_token])
          chat = Chat.find_by(application_id: application.id, number: params[:chat_chat_number])
          messages = chat.messages.as_json(only: [:number, :content, :created_at, :updated_at])
          if messages
            render json: {data: messages},status: :ok
          else
            render json: "Unsuccessful: no messages for that chat", status: :not_found
          end
        end
      end
      def show
        application = Application.find_by_token(params[:application_token])
        chat = Chat.find_by(application_id: application.id, number: params[:chat_chat_number])
        message = Message.find_by(chat_id: chat.id, number: params[:message_number])
        if message
          render json: {data: message},status: :ok
        else
          render json: "the message is not found", status: :not_found
        end
      end

      def create
        content_to_use = request.body.read()
        application = Application.find_by_token(params[:application_token])
        chat = Chat.find_by(application_id: application.id, number: params[:chat_chat_number])
        message = Message.new({chat_id: chat.id,number: 8, body: content_to_use})

        if message.save
          render json: message.as_json(only: [:chat_number, :created_at])
        else
          render json: message.errors, status: :unprocessable_entity
        end
      end
      def destroy
        application = Application.find_by_token(params[:application_token])
        chat = Chat.find_by(application_id: application.id, number: params[:chat_chat_number])
        message = Message.find_by(chat_id: chat.id, number: params[:message_number])

        if message.destroy
          render json:"message deleted Successfully",status: :ok
        else
          render json: message.errors, status: :unprocessable_entity
        end
      end
      def update
        content_to_use = request.body.read()
        application = Application.find_by_token(params[:application_token])
        chat = Chat.find_by(application_id: application.id, number: params[:chat_chat_number])
        message = Message.find_by(chat_id: chat.id, number: params[:message_number])
        if message.update({body: content_to_use})
          render json:"message updated Successfully",status: :ok
        else
          render json: message.errors, status: :unprocessable_entity
        end

      end

      def search
        cached_response = params[:query]
        render json: cached_response, status: :ok
      end

    end
  end
end
