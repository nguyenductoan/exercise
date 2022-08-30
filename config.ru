Dir["./controllers/*.rb"].each {|file| require file }

class Application
  def call(env)
    req = Rack::Request.new(env)
    case req.path_info
    when /hotels/
      hotels_controller = HotelsController.new(req)
      hotels_controller.index
    else
      [404, {'Content-Type' => 'text/html'}, ['Bad request']]
    end
  end
end

run Application.new
