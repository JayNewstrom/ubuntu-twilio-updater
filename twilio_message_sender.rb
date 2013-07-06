require 'rubygems'
require 'twilio-ruby'
require 'yaml'

class TwilioMessageSender

  def initialize(account_sid, auth_token, from, always_send, error_send)
    @client = Twilio::REST::Client.new account_sid, auth_token

    @from = from
    @always_send_people = always_send
    @error_send_people = error_send
  end

  def send_message_with_name(message)
    internal_send_message_with_name @error_send_people, message
  end

  def send_error_message_with_name(message)
    internal_send_message_with_name @always_send_people, message
  end

private

  def internal_send_message_with_name(people, message)
    messages = []
    people.each do |person|
      person_message = "#{person['name']}, " + message
      messages.push({message: person_message, person: person})
    end

    messages.each do |obj|
      person_message = obj[:message]
      person = obj[:person]

      break_message_into_messages(person_message).each do |short_message|
        @client.account.sms.messages.create(
          :from => @from,
          :to => person['number'],
          :body => short_message
        )
      end
    end
  end

  # this only accounts for up to 9 messages,
  # you shouldn't be sending this in a text
  # if it is more than 10 messages long!
  def break_message_into_messages(message)
    return [message] if message.length <= 160

    messages = []
    number_of_messages = message.length / 155 + 1
    (1..number_of_messages).each do |message_number|
      short_message = message.slice((message_number - 1) * 155, 155)

      short_message.prepend "(#{message_number}/#{number_of_messages})"
      messages.push short_message
    end

    return messages
  end

end
