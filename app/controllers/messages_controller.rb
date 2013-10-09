class MessagesController < ApplicationController
  def retrieve
    country_code = IsoCountryCodes.find(params[:FromCountry]).calling
    full_phone = "#{country_code}#{params[:From]}"
    user = User.find_by_phone_number(full_phone)
    body = params[:Body]
    user.respond_to_incoming_message(body)

    
    render status :status
  end

end