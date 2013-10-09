class User < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  attr_accessible :infected, :phone_number, :tested_at, :user_id

  belongs_to :original_partner,
             :class_name => 'User',
             :foreign_key => :user_id

  has_many :sexual_partners,
           :class_name => 'User',
           :foreign_key => :user_id

  def welcome_text
    body ='Welcome to Bonk! When is the last time you were tested for STDs? Please respond with a date or "never" if you have never been tested.'
    Notifier.send_txt(body, phone_number)
  end

  def date_response(date)
    tested_date = Chronic.parse(date)

    if tested_date.nil?
      message = "You have never been tested for STDs! Please get tested to resist the spread of disease."
    elsif tested_date < 3.months.ago
      message = "You were tested #{time_ago_in_words(tested_date)} ago. Please get tested to resist the spread of disease."
    end
    Notifier.send_txt(message, phone_number)
    options_message
    update_attributes(tested_at: Time.now.utc)
  end

  def options_message
    body = "How to use:
      After sexual activity:

      -Text us the sexual partner's phone # to add them to your network.

      After you are tested:

      -Text POSITIVE if you contracted a STD.
      -Text NEGATIVE if you are STD free."
    Notifier.send_txt(body, phone_number)
  end

  def create_sexual_partner(phone_number)
    sexual_partners << User.find_or_create_by(phone_number: phone_number)    
  end

  def tested_positive

    update_attributes(tested_at: Time.now.utc)
  end

  def tested_negative
    update_attributes(tested_at: Time.now.utc)
  end

  def tested_positive_confirmation_message
    body = "OK! We'll anonymously let your network know that they are at risk."
    Notifier.send_txt(body, phone_number)
  end

  def respond_to_incoming_message(body)
    if tested_at.nil?
      date_response(body)

    elsif body =~ /^[-+]?[0-9]+$/
      partners_phone_number = Phoner::Phone.parse(body)
      create_sexual_partner(partners_phone_number.to_s)
    elsif body.downcase.include?('positive') 
      tested_positive
    elsif body.downcase.include?('negative') 
      tested_negative
    end
  end
end
