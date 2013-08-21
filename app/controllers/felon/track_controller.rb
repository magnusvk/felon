class Felon::TrackController < ApplicationController
  def view
    Felon::Counter.record_view(params[:variant_id]) if track?
    send_blank_response
  end

  def interaction
    Felon::Counter.record_interaction(params[:variant_id]) if track?
    send_blank_response
  end

  def conversion
    Felon::Counter.record_conversion(params[:variant_id]) if track?
    send_blank_response
  end

  def send_blank_response
    respond_to do |format|
      format.js do
        render json: { howdy: "y'all" }, callback: params[:callback]
      end
      format.json do
        render json: { howdy: "y'all" }
      end
      format.any do
        send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), :type => "image/gif", :disposition => "inline")
      end
    end
  end

  def track?
    @has_felon_track ||= self.respond_to?(:felon_track?)
    if @has_felon_track
      felon_track?
    else
      true
    end
  end
end
