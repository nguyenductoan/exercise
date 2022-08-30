class BaseSource
  def initialize(data)
    @data = data.is_a?(Hash) ? data : {}
  end

  def id
    ''
  end

  def destination_id
    ''
  end

  def name
    ''
  end

  def location
    {
      'lat' => latitude,
      'lng' => longtitude,
      'address' => address,
      'city' => city,
      'country' => country
    }
  end

  def latitude
    ''
  end

  def longtitude
    ''
  end

  def address
    ''
  end

  def city
    ''
  end

  def country
    ''
  end

  def postal_code
    ''
  end

  def description
    ''
  end

  def images
    {}
  end

  def amenities
    {}
  end

  def booking_conditions
    []
  end

  private

  def string_format(value)
    value.to_s.strip
  end
end
