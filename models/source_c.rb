require_relative 'base_source'

class SourceC < BaseSource
  SOURCE_URL = 'http://www.mocky.io/v2/5ebbea1f2e00002b009f4000'.freeze

  def self.source_url
    SOURCE_URL
  end

  def id
    string_format(@data['id'])
  end

  def destination_id
    string_format(@data['destination'])
  end

  def name
    string_format(@data['name'])
  end

  def latitude
    string_format(@data['lat'])
  end

  def longtitude
    string_format(@data['lng'])
  end

  def address
    string_format(@data['address'])
  end

  def amenities
    return {} unless @data['amenities'].is_a?(Array)
    {
      'general' => @data['amenities'].map { |i| string_format(i).downcase }
    }
  end

  # hash
  def images
    return {} unless @data['images'].is_a?(Hash)
    result = {}
    @data['images'].each do |k, v|
      next unless v.is_a?(Array)

      result[k] = v.map do |h|
        next unless h.is_a?(Hash)
        next if h['url'].nil? || h['description'].nil?

        {
          'link' => h['url'],
          'description' => h['description']
        }
      end.compact
    end
    result
  end

  def description
    string_format(@data['info'])
  end
end
