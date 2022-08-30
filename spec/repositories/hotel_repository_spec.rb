require_relative '../spec_helper'

RSpec.describe HotelRepository do
  describe '#fetch' do
    context 'fetch and parse data from url error' do
      before do
        allow(JSON).to receive(:parse).and_raise(StandardError.new('parse error'))
      end

      let(:result) { described_class.fetch }

      it 'return empty hash' do
        expect(result).to match([])
      end
    end

    context 'hotel data is duplicated in serveral sources' do
      before do
        expect(HotelRepository).to receive(:fetch_data_from_url).with(SourceA.source_url).and_return(
          [
            { 'Id' => 'h1', 'DestinationId' => 'des_1', 'Name' => 'Nikko' },
            { 'Id' => 'h2', 'DestinationId' => 'des_1', 'Name' => 'Diamond' }
          ]
        )
        expect(HotelRepository).to receive(:fetch_data_from_url).with(SourceB.source_url).and_return(
          [
            { 'hotel_id' => 'h1', 'destination_id' => 'des_1', 'hotel_name' => 'Nikko SG' }, # duplicated
            { 'hotel_id' => 'h3', 'destination_id' => 'des_2', 'hotel_name' => 'Gold' }
          ]
        )
        expect(HotelRepository).to receive(:fetch_data_from_url).with(SourceC.source_url).and_return(
          [
            { 'id' => 'h3', 'destination' => 'des_2', 'name' => 'Gold A' }, # duplicated
            { 'id' => 'h4', 'destination' => 'des_3', 'name' => 'Silver' }
          ]
        )
      end

      let(:result) { described_class.fetch }

      it 'should return array of uniq hotel id' do
        expect(result).not_to be_empty
        expect(result.map(&:id)).to match_array(['h1', 'h2', 'h3', 'h4'])
      end
    end
  end
end
