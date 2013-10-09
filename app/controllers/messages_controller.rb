class MessagesController < ApplicationController
  def retrieve
    full_phone = IsoCountryCodes.find(params[:FromCountry]) + params[:From]
    user = User.find_by_phone_number(full_phone)
    body = params[:Body]
    user.respond_to_incoming_message(body)

    
    render json: { head :no_content }
    end
  end

end