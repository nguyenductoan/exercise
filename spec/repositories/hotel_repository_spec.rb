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
  end
end
