Dir["./models/*.rb"].each {|file| require file }
Dir["./repositories/*.rb"].each {|file| require file }

class HotelsQuery
  def initialize(ids = [], destination_id = '')
    @ids = ids.is_a?(Array) ? ids : []
    @destination_id = destination_id
  end

  def call
    hotels = ::HotelRepository.fetch
    if filter_by_ids? && filter_by_destination_id?
      hotels = hotels.filter { |h| @ids.include?(h.id) && h.destination_id == @destination_id }
    elsif filter_by_destination_id?
      hotels = hotels.filter { |h| h.destination_id == @destination_id }
    elsif filter_by_ids?
      hotels = hotels.filter { |h| @ids.include?(h.id) }
    end
    return hotels
  end

  private

  def filter_by_ids?
    !@ids.empty?
  end

  def filter_by_destination_id?
    !(@destination_id.nil? || @destination_id.empty?)
  end
end
