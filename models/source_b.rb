require_relative 'base_source'

class SourceB < BaseSource
  SOURCE_URL = 'http://www.mocky.io/v2/5ebbea102e000029009f3fff'.freeze

  def self.source_url
    SOURCE_URL
  end

  def id
    string_format(@data['hotel_id'])
  end

  def destination_id
    string_format(@data['destination_id'])
  end

  def name
    string_format(@data['hotel_name'])
  end

  def address
    string_format(@data.dig('location', 'address'))
  end

  def country
    string_format(@data.dig('location', 'country'))
  end

  def amenities
    return {} unless @data['amenities'].is_a?(Hash)
    result = {}
    @data['amenities'].each do |k, v|
      result[k.downcase] = v.map { |i| string_format(i) }
    end
    result
  end

  def images
    return {} unless @data['images'].is_a?(Hash)
    result = {}
    @data['images'].each do |k, v|
      next unless v.is_a?(Array)

      result[k] = v.map do |h|
        next unless h.is_a?(Hash)
        next if h['link'].nil? || h['caption'].nil?

        {
          'link' => h['link'],
          'description' => h['caption']
        }
      end.compact
    end
    result
  end

  def description
    string_format(@data['details'])
  end

  def booking_conditions
    return [] unless @data['booking_conditions'].is_a?(Array)
    @data['booking_conditions'].map { |i| string_format(i) }
  end
end
