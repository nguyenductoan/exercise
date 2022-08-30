require_relative '../spec_helper'

RSpec.describe SourceC do
  subject { described_class.new(data) }

  describe 'init with argument is not a hash' do
    let(:data) { nil }
    it do
      expect(subject.id).to eq("")
      expect(subject.destination_id).to eq("")
      expect(subject.name).to eq("")
      expect(subject.latitude).to eq("")
      expect(subject.longtitude).to eq("")
      expect(subject.address).to eq("")
      expect(subject.amenities).to eq({})
      expect(subject.images).to eq({})
      expect(subject.description).to eq("")
    end
  end

  describe '.id' do
    let(:data) { { 'id' => 'aafd' } }
    it { expect(subject.id).to eq('aafd') }
  end

  describe '.destination' do
    let(:data) { { 'destination' => 'asdfg' } }
    it { expect(subject.destination_id).to eq('asdfg') }
  end

  describe '.name' do
    let(:data) { { 'name' => 'Nikko' } }
    it { expect(subject.name).to eq('Nikko') }
  end

  describe '.latitude' do
    let(:data) { { 'lat' => '522342' } }
    it { expect(subject.latitude).to eq('522342') }
  end

  describe '.longtitude' do
    let(:data) { { 'lng' => '645223' } }
    it { expect(subject.longtitude).to eq('645223') }
  end

  describe '.address' do
    let(:data) { { 'address' => 'my address' } }
    it { expect(subject.address).to eq('my address') }
  end

  describe '.amenities' do
    context 'is not a Hash value' do
      let(:data) do
        {
          'amenities' => 'iron'
        }
      end

      it 'return an empty hash' do
        expect(subject.amenities).to eq({})
      end
    end

    context 'is a hash value' do
      let(:data) do
        {
          'amenities' => ['CHAIR', 'Water']
        }
      end

      it 'return hash with value of array is downcase' do
        expect(subject.amenities.count).to eq(1)
        expect(subject.amenities.keys).to match_array(['general'])
        expect(subject.amenities['general']).to match_array(['chair', 'water'])
      end
    end
  end

  describe '.images' do
    context 'is not a Hash value' do
      let(:data) do
        {
          'images' => ['abc', 'def']
        }
      end

      it 'return an empty hash' do
        expect(subject.images).to eq({})
      end
    end

    context 'with valid Hash value' do
      let(:data) do
        {
          'images' => {
            'rooms' => [
              { 'url' => 'https://cloudfront.net/img1.jpg', 'description' => 'no caption' },
              { 'link' => 'https://cloudfront.net/img2.jpg', 'description' => 'no caption' }, # missing 'url' key
              { 'url' => 'https://cloudfront.net/img3.jpg', 'caption' => 'no caption' } # missing 'caption' key
            ],
            'amenities' => [
              { 'url' => 'https://cloudfront.net/img3.jpg', 'description' => 'no caption' },
              { 'url' => 'https://cloudfront.net/img4.jpg', 'description' => 'no caption' }
            ],
            'site' => 'https://cloudfront.net/img4.jpg', # image group is invalid
            'beach' => ['https://cloudfront.net/img4.jpg'] # image info is invalid
          }
        }
      end

      it 'returns hash value of image info with item of invalid values removed and "caption" is converted to "description"' do
        expect(subject.images.keys).to match_array(['rooms', 'amenities', 'beach'])
        expect(subject.images['rooms'].count).to eq(1)
        expect(subject.images['amenities'].count).to eq(2)
        expect(subject.images['beach'].count).to eq(0)
      end

      it 'remove image group with invalid value ("site")' do
        expect(subject.images.keys).not_to include('site')
      end
    end
  end

  describe '.description' do
    let(:data) { { 'info' => 'my description' } }
    it { expect(subject.description).to eq('my description') }
  end
end
