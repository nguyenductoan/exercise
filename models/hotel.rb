class Hotel
  attr_reader :id # string
  attr_reader :destination_id #string
  attr_reader :name # string
  attr_reader :description # string
  attr_reader :location # hash
  attr_reader :amenities # hash
  attr_reader :images # hash
  attr_reader :booking_conditions # array

  def initialize(
    id: '',
    destination_id: '',
    name: '',
    description: '',
    location: {},
    amenities: {},
    images: {},
    booking_conditions: []
  )
    @id = id || ''
    @destination_id = destination_id || ''
    @name = name || ''
    @description = description || ''
    @location = location || ''
    @amenities = amenities || {}
    @images = images || {}
    @booking_conditions = booking_conditions || []
  end

  def update(s)
    return unless s.is_a?(BaseSource)
    @id = s.id
    @destination_id = s.destination_id

    # name
    @name = s.name if @name.nil? || @name.empty?

    # description
    @description = s.description if @description.to_s.length < s.description.to_s.length

    # location
    update_location(s.location)

    # amenities
    update_amenities(s.amenities)

    # image
    update_images(s.images)

    # booking_conditions
    @booking_conditions = s.booking_conditions if @booking_conditions.length < s.booking_conditions.length
  rescue StandardError => e
    puts "Update hotel error (hotel id: #{@id}): #{e}"
  end

  def to_h
    {
      id: @id,
      destination_id: @destination_id,
      name: @name,
      location: @location,
      description: @description,
      amenities: @amenities,
      images: @images,
      booking_conditions: @booking_conditions
    }
  end

  private

  def update_location(location)
    location.each do |k, v|
      @location[k] = v if @location[k].to_s.length < v.length
    end
  end

  def update_amenities(amenities)
    if @amenities.count == 0 ||
        @amenities.count < amenities.count ||
        @amenities.count == amenities.count && @amenities.values.flatten.count < amenities.values.flatten.count
      @amenities = amenities
    end
  end

  def update_images(images)
    images.each do |group_name, info_list|
      if @images[group_name].nil?
        @images[group_name] = info_list
      else
        image_urls = @images[group_name].map { |i| i['link'] }
        # add new url to the group
        info_list.each do |info|
          if !image_urls.include?(info['link'])
            @images[group_name] << info
          end
        end
      end
    end
  end
end
