require 'uri'
require 'net/http'
Dir['./models/*.rb'].each {|file| require file }

class HotelRepository
  def self.fetch
    hotel_map = {}
    threads = {}
    mutex = Mutex.new
    [SourceA, SourceB, SourceC].each do |source_class|
      threads[source_class] = Thread.new do
        source_data = fetch_data_from_url(source_class.source_url)
        source_data.each do |data|
          hotel_source = source_class.new(data)

          # ignore source without "id" or without "destination_id"
          next if hotel_source.id.empty? || hotel_source.destination_id.empty?

          mutex.synchronize do
            hotel = hotel_map[hotel_source.id] || Hotel.new
            hotel.update(hotel_source)
            hotel_map[hotel_source.id] = hotel
          end
        end
      end
    end
    threads.values.each(&:join)
    hotel_map.values
  end

  def self.fetch_data_from_url(uri)
    url = URI.parse(uri)
    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = (ENV['HTTP_READ_TIMEOUT'] || 10).to_i # seconds
    http.open_timeout = (ENV['HTTP_OPEN_TIMEOUT'] || 10).to_i # seconds

    resp = http.get(url)
    return [] unless resp.is_a?(Net::HTTPSuccess)
    JSON.parse(resp.body)
  rescue StandardError => e
    puts "fetch data from #{uri} error: #{e}"
    []
  end
end
