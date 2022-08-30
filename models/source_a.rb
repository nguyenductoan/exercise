require_relative 'base_source'

class SourceA < BaseSource
  SOURCE_URL = 'http://www.mocky.io/v2/5ebbea002e000054009f3ffc'.freeze

  def self.source_url
    SOURCE_URL
  end

  def id
    string_format(@data['Id'])
  end

  def destination_id
    string_format(@data['DestinationId'])
  end

  def name
    string_format(@data['Name'])
  end

  def latitude
    string_format(@data['Latitude'])
  end

  def longtitude
    string_format(@data['Longitude'])
  end

  def address
    string_format(@data['Address'])
  end

  def city
    string_format(@data['City'])
  end

  def country
    string_format(@data['Country'])
  end

  def postal_code
    string_format(@data['PostalCode'])
  end

  def description
    string_format(@data['Description'])
  end

  def amenities
    return {} unless @data['Facilities'].is_a?(Array)
    {
      general: @data['Facilities'].map { |i| string_format(i).downcase }
    }
  end
end
