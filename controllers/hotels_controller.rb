require 'json'

Dir['./services/*.rb'].each {|file| require file }

class HotelsController
  attr_reader :params

  def initialize(req)
    @params = req.params
  end

  def index
    hotels = ::HotelsQuery.new(params['hotels'], params['destination']).call

    [200, {'Content-Type' => 'application/json'}, [hotels.map(&:to_h).to_json]]
  end
end
