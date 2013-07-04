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
    people.each do |person|
      @client.account.sms.messages.create(
        :from => @from,
        :to => person['number'],
        :body => "#{person['name']}, #{message}"
      )
    end
  end

end
