class Felon::TrackController < ActionController::Base
  def view
    Felon::Counter.record_view(params[:variant_id])
    send_blank_gif
  end

  def conversion
    Felon::Counter.record_conversion(params[:variant_id])
    send_blank_gif
  end

  def send_blank_gif
    send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), :type => "image/gif", :disposition => "inline")
  end
end
