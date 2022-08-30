require_relative '../spec_helper'

RSpec.describe SourceB do
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
      expect(subject.country).to eq("")
      expect(subject.city).to eq("")
      expect(subject.postal_code).to eq("")
      expect(subject.description).to eq("")
      expect(subject.images).to eq({})
      expect(subject.amenities).to eq({})
    end
  end

  describe '.id' do
    let(:data) { { 'hotel_id' => 'aafd' } }
    it { expect(subject.id).to eq('aafd') }
  end

  describe '.destination_id' do
    let(:data) { { 'destination_id' => 'asdfg' } }
    it { expect(subject.destination_id).to eq('asdfg') }
  end

  describe '.name' do
    let(:data) { { 'hotel_name' => 'Nikko' } }
    it { expect(subject.name).to eq('Nikko') }
  end

  describe '.address' do
    context 'location address is not present' do
      let(:data) do
        {
          'location' => {
            'new_address' => 'my new address'
          }
        }
      end
      it { expect(subject.address).to eq('') }
    end
    context 'location address is present' do
      let(:data) do
        {
          'location' => {
            'address' => 'my address'
          }
        }
      end
      it { expect(subject.address).to eq('my address') }
    end
  end

  describe '.country' do
    context 'location country is not present' do
      let(:data) do
        {
          'location' => {
            'country_name' => 'Viet Nam'
          }
        }
      end
      it { expect(subject.country).to eq('') }
    end
    context 'location country is present' do
      let(:data) do
        {
          'location' => {
            'country' => 'Viet Nam'
          }
        }
      end
      it { expect(subject.country).to eq('Viet Nam') }
    end
  end

  describe '.amenities' do
    context 'is not a Hash value' do
      let(:data) do
        {
          'amenities' => ['abc', 'def']
        }
      end

      it 'return an empty hash' do
        expect(subject.amenities).to eq({})
      end
    end

    context 'is a hash value' do
      let(:data) do
        {
          'amenities' => {
            'General' => ['chair', 'water'],
            'ROOM' => ['book', 'table']
          }
        }
      end

      it 'return hash value with keys is downcase' do
        expect(subject.amenities.count).to eq(2)
        expect(subject.amenities.keys).to match_array(['general', 'room'])
        expect(subject.amenities['general']).to match_array(['chair', 'water'])
        expect(subject.amenities['room']).to match_array(['book', 'table'])
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
              { 'link' => 'https://cloudfront.net/img1.jpg', 'caption' => 'no caption' },
              { 'link' => 'https://cloudfront.net/img2.jpg', 'caption' => 'no caption' },
            ],
            'site' => [
              { 'link' => 'https://cloudfront.net/img3.jpg', 'caption' => 'no caption' },
              { 'url' => 'https://cloudfront.net/img4.jpg', 'caption' => 'no caption' }, # key 'url' is not recognized
            ],
            'amenities' => 'https://cloudfront.net/img4.jpg', # image group is invalid
            'beach' => ['https://cloudfront.net/img4.jpg'] # image info is invalid
          }
        }
      end

      it 'returns hash value of image info with item of unrecognized key removed and "caption" is converted to "description"' do
        expect(subject.images.keys).to match_array(['rooms', 'site', 'beach'])
        expect(subject.images['rooms'].count).to eq(2)
        expect(subject.images['site'].count).to eq(1)
        expect(subject.images['beach'].count).to eq(0)
      end

      it 'remove image group with invalid value ("amenities")' do
        expect(subject.images.keys).not_to include('amenities')
      end
    end
  end

  describe '.description' do
    let(:data) { { 'details' => 'my description' } }
    it { expect(subject.description).to eq('my description') }
  end

  describe '.booking_conditions' do
    context 'is not an array' do
      let(:data) { { 'booking_conditions' => 'no smoking' } }
      it { expect(subject.booking_conditions).to eq([]) }
    end

    context 'is an array' do
      let(:data) { { 'booking_conditions' => ['no smoking', 'no pet'] } }
      it { expect(subject.booking_conditions).to match_array(['no smoking', 'no pet']) }
    end
  end
end
