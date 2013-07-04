require_relative 'twilio_message_sender'

def number_of_upgrades
  return %x(aptitude search "~U" | wc -l).to_i
end

def perform_upgrade
  return %x(unattended-upgrade)
end

if number_of_upgrades > 0

  config = YAML.load_file('ubuntu_updater.yml')

  twilio_account = config['twilio_account_sid']
  twilio_auth_token = config['twilio_auth_token']
  twilio_from = config['twilio_from_number']
  always_send = config['always_send']
  error_send = config['error_send']
  error_send = error_send.concat always_send
  server_name = config['server_name']

  twilio_message_sender = TwilioMessageSender.new twilio_account, twilio_auth_token, twilio_from, always_send, error_send

  twilio_message_sender.send_message_with_name "There are #{number_of_upgrades} upgrades on #{server_name}"
  errors = perform_upgrade
  remaining_upgrades = number_of_upgrades

  if remaining_upgrades > 0 || errors.length > 0
    twilio_message_sender.send_error_message_with_name "#{server_name} failed to update, there are #{number_of_upgrades} remaining upgrades"
    puts "Failed to upgrade, #{remaining_upgrades} remaining upgrades"
    puts "ERROR - #{errors}" if errors.length > 0
  else
    twilio_message_sender.send_message_with_name "#{server_name} updated successfully"
  end

end
