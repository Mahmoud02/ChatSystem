class ChatJob
  include Sidekiq::Worker

  def perform(applicationToken)
    #NOT COMPLETED YET
    @application = Application.find_by_token(applicationToken)
    counter = $redis.get(@application.id.to_s)
    counter_value = (counter.to_i )+ 1
    chat = Chat.new({number: counter_value,application_id: @application.id})
    if chat.save
      $redis.set(@application.id.to_s,counter_value.to_s)
    end

  end

end
