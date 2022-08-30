require_relative '../spec_helper'

RSpec.describe HotelsQuery do
  describe 'call' do
    let!(:hotel_1) { Hotel.new(id: 'h1', destination_id: 'des_1') }
    let!(:hotel_2) { Hotel.new(id: 'h2', destination_id: 'des_1') }
    let!(:hotel_3) { Hotel.new(id: 'h3', destination_id: 'des_2') }

    let(:result) { query_obj.call }

    before do
      expect(::HotelRepository).to receive(:fetch).and_return([hotel_1, hotel_2, hotel_3])
    end

    context 'with filter by ids and destination_id' do
      let(:query_obj) { described_class.new(['h1'], 'des_1') }

      it do
        expect(result.count).to eq(1)
        expect(result.map(&:id)).to match_array([hotel_1.id])
      end
    end

    context 'with filter by ids' do
      let(:query_obj) { described_class.new(['h1', 'h3'], nil) }

      it do
        expect(result.count).to eq(2)
        expect(result.map(&:id)).to match_array([hotel_1.id, hotel_3.id])
      end
    end

    context 'with filter by destination_id' do
      let(:query_obj) { described_class.new([], 'des_1') }

      it do
        expect(result.count).to eq(2)
        expect(result.map(&:id)).to match_array([hotel_1.id, hotel_2.id])
      end
    end

    context 'without filter' do
      let(:query_obj) { described_class.new }

      it do
        expect(result.count).to eq(3)
        expect(result.map(&:id)).to match_array([hotel_1.id, hotel_2.id, hotel_3.id])
      end
    end

    context 'filter with wrong ids and destination_id' do
      let(:query_obj) { described_class.new(['sadf'], 'bsfd') }

      it do
        expect(result.count).to eq(0)
      end
    end
  end
end
