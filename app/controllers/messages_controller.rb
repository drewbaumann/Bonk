class MessagesController < ApplicationController
  def retrieve
    user = User.find_by_phone_number(params[:From])
    body = params[:Body]
    user.respond_to_incoming_message(body)

    
    render json: { head :no_content }
    end
  end

end