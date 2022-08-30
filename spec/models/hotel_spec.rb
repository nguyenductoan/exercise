require_relative '../spec_helper'

RSpec.describe Hotel do
  describe 'init' do
    let(:hotel) { described_class.new(**hotel_data) }

    let(:hotel_data) do
      {
        id: 'iJhz',
        destination_id: 5432,
        name: 'Nikko',
        description: 'my desc',
        location: {
          'lat' => '1.264751',
          'lng' => '103.824006',
          'address' => '8 Sentosa Gateway, Beach Villas, 098269',
          'city' => 'HCM',
          'country' => 'VN'
        },
        amenities: {
          general: ['aircon', 'tv', 'coffee machine', 'kettle', 'hair dryer', 'iron', 'tub']
        },
        images: {
          'rooms' => [
            { 'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg', 'description' => 'Bathroom' }
          ],
          'amenities' => [
            { 'link': 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/6.jpg', 'description' => 'Sentosa Gateway' }
          ]
        }
      }
    end

    it do
      expect(hotel.id).to eq(hotel_data[:id])
      expect(hotel.destination_id).to eq(hotel_data[:destination_id])
      expect(hotel.name).to eq(hotel_data[:name])
      expect(hotel.description).to eq(hotel_data[:description])
      expect(hotel.booking_conditions).to match_array(hotel_data[:booking_conditions])

      expect(hotel.location).to match(hotel_data[:location])
      expect(hotel.amenities).to match(hotel_data[:amenities])
      expect(hotel.images).to match(hotel_data[:images])
    end
  end

  describe 'update' do
    describe 'name' do
      context 'already has value' do
        let(:hotel) { Hotel.new(name: 'Nikko') }
        let(:source) { SourceA.new({ 'Name' => 'New Name' }) }

        before do
          hotel.update(source)
        end

        it 'keep old value' do
          expect(hotel.name).to eq('Nikko')
        end
      end

      context 'current value is empty' do
        let(:hotel) { Hotel.new(name: nil) }
        let(:source) { SourceA.new({ 'Name' => 'New Name' }) }

        before do
          hotel.update(source)
        end

        it 'keep update to new value' do
          expect(hotel.name).to eq('New Name')
        end
      end
    end

    describe 'description' do
      context 'new value has shorter length than old value' do
        let(:hotel) { Hotel.new(description: 'very long old description...') }
        let(:source) { SourceA.new({ 'Description' => 'new short desc' }) }

        before do
          hotel.update(source)
        end

        it 'keep old value' do
          expect(hotel.description).to eq('very long old description...')
        end
      end

      context 'new value has longer length than old value' do
        let(:hotel) { Hotel.new(description: 'old short desc') }
        let(:source) { SourceA.new({ 'Description' => 'very long new description...' }) }

        before do
          hotel.update(source)
        end

        it 'update new value value' do
          expect(hotel.description).to eq('very long new description...')
        end
      end
    end

    describe 'location' do
      let(:hotel) do
        Hotel.new(
          location: {
            'lat' => '123',
            'lng' => '2454',
            'address' => 'D1',
            'city' => 'Ho Chi Minh',
            'country' => 'VN'
          }
        )
      end
      let(:source) do
        SourceA.new(
          {
            'Latitude' => '64',
            'Longitude' => '35',
            'Address' => '123, District 1',
            'City' => 'HCM',
            'Country' => 'VietNam'
          }
        )
      end

      before do
        hotel.update(source)
      end

      it 'keep all values that has longer length' do
        expect(hotel.location).to match(
          {
            'lat' => '123',
            'lng' => '2454',
            'address' => '123, District 1',
            'city' => 'Ho Chi Minh',
            'country' => 'VietNam'
          }
        )
      end
    end

    describe 'amenities' do
      before do
        hotel.update(source)
      end

      context 'old value has more group than new value' do
        let!(:hotel) do
          Hotel.new(
            amenities: {
              general: ['asd', 'gwe'],
              rooms: ['wev']
            }
          )
        end
        let!(:source) do
          SourceB.new(
            { 'amenities' => { general: ['gfd', 'ges'] } }
          )
        end

        it 'keep old value' do
          expect(hotel.amenities).to match(
            {
              general: ['asd', 'gwe'],
              rooms: ['wev']
            }
          )
        end
      end

      context 'old value is empty' do
        let!(:hotel) do
          Hotel.new(amenities: {})
        end
        let!(:source) do
          SourceB.new(
            {
              'amenities' => {
                'general' => ['gfd', 'ges'],
                'rooms' => ['wev']
              }
            }
          )
        end

        it 'update to new value' do
          expect(hotel.amenities).to match(
            {
              'general' => ['gfd', 'ges'],
              'rooms' => ['wev']
            }
          )
        end
      end

      context 'old value has less number of groups than new value' do
        let!(:hotel) do
          Hotel.new(
            amenities: {
              general: ['asd', 'gwe']
            }
          )
        end
        let!(:source) do
          SourceB.new(
            {
              'amenities' => {
                'general' => ['gfd', 'ges'],
                'rooms' => ['wev']
              }
            }
          )
        end

        it 'update to new value' do
          expect(hotel.amenities).to match(
            {
              'general' => ['gfd', 'ges'],
              'rooms' => ['wev']
            }
          )
        end
      end

      context 'old value has less number of items than new value' do
        let!(:hotel) do
          Hotel.new(
            amenities: {
              'general' => ['asd', 'gwe'],
              'rooms' => ['wev']
            }
          )
        end
        let!(:source) do
          SourceB.new(
            {
              'amenities' => {
                'general' => ['gfd', 'ges'],
                'rooms' => ['wev', 'sse', 'asdfs']
              }
            }
          )
        end

        it 'update to new value' do
          expect(hotel.amenities).to match(
            {
              'general' => ['gfd', 'ges'],
              'rooms' => ['wev', 'sse', 'asdfs']
            }
          )
        end
      end

    end

    describe 'images' do
      before do
        hotel.update(source)
      end

      context 'when groups does not exist' do
        let!(:hotel) do
          Hotel.new(
            images: {
              'rooms' => [
                { 'link' => 'https://cloudfront.net/img1.jpg', 'description' => 'desc'}
              ]
            }
          )
        end
        let!(:source) do
          SourceB.new(
            {
              'images' => {
                'site' => [
                  { 'link' => 'https://cloudfront.net/img2.jpg', 'caption' => 'desc' }
                ]
              }
            }
          )
        end

        it 'add new group to image hash' do
          expect(hotel.images).to match(
            {
              'rooms' => [
                { 'link' => 'https://cloudfront.net/img1.jpg', 'description' => 'desc'}
              ],
              'site' => [
                { 'link' => 'https://cloudfront.net/img2.jpg', 'description' => 'desc' }
              ]
            }
          )
        end
      end

      context 'when groups exist' do
        let!(:hotel) do
          Hotel.new(
            images: {
              'rooms' => [
                { 'link' => 'https://cloudfront.net/img1.jpg', 'description' => 'desc 1'},
                { 'link' => 'https://cloudfront.net/img3.jpg', 'description' => 'desc 3'}
              ]
            }
          )
        end
        let!(:source) do
          SourceB.new(
            {
              'images' => {
                'rooms' => [
                  { 'link' => 'https://cloudfront.net/img0.jpg', 'caption' => 'desc 0' },
                  { 'link' => 'https://cloudfront.net/img1.jpg', 'caption' => 'desc 1' },
                  { 'link' => 'https://cloudfront.net/img2.jpg', 'caption' => 'desc 2' }
                ],
                'site' => [
                  { 'link' => 'https://cloudfront.net/img1.jpg', 'caption' => 'desc 1'}
                ]
              }
            }
          )
        end

        it 'add new images to the list' do
          expect(hotel.images.keys).to match_array(['rooms', 'site'])
          expect(hotel.images['rooms'].map { |i| i['link'] })
            .to match_array(
              [
                'https://cloudfront.net/img0.jpg',
                'https://cloudfront.net/img1.jpg',
                'https://cloudfront.net/img2.jpg',
                'https://cloudfront.net/img3.jpg'
              ]
            )
          expect(hotel.images['rooms'].map { |i| i['description'] })
            .to match_array([ 'desc 0', 'desc 1', 'desc 2', 'desc 3' ])
          expect(hotel.images['site'].first)
            .to match({ 'link' => 'https://cloudfront.net/img1.jpg', 'description' => 'desc 1'})
        end
      end
    end

    describe 'booking_conditions' do
      context 'new value has less items than old value' do
        let(:hotel) do
          Hotel.new(
            booking_conditions: ['abc', 'def', 'gew']
          )
        end
        let(:source) do
          SourceB.new(
            { 'booking_conditions' => ['gfd', 'ges'] }
          )
        end

        before do
          hotel.update(source)
        end

        it 'keep old value' do
          expect(hotel.booking_conditions).to match_array(['abc', 'def', 'gew'])
        end
      end

      context 'new value has more items than old value' do
        let(:hotel) do
          Hotel.new(
            booking_conditions: ['abc', 'def', 'gew']
          )
        end
        let(:source) do
          SourceB.new(
            { 'booking_conditions' => ['gfd', 'ges', 'dsgs', 'wegw'] }
          )
        end

        before do
          hotel.update(source)
        end

        it 'update to new value' do
          expect(hotel.booking_conditions).to match_array(['gfd', 'ges', 'dsgs', 'wegw'])
        end
      end
    end
  end
end
