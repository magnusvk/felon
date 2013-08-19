Felon::Engine.routes.draw do
  get '/track/:variant_id/view' => 'felon/track#view', as: 'track_view'
  get '/track/:variant_id/interaction' => 'felon/track#interaction', as: 'track_interaction'
  get '/track/:variant_id/conversion' => 'felon/track#conversion', as: 'track_conversion'
end
