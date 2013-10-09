module Notifier
  def self.send_txt(body, to, from='+13105041326')
    TWILIO_CLIENT.account.messages.create(
      :from => from,
      :to => to,
      :body => body
    )
  end
end