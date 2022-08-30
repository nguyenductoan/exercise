require_relative '../spec_helper'

RSpec.describe SourceA do
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
      expect(subject.city).to eq("")
      expect(subject.country).to eq("")
      expect(subject.postal_code).to eq("")
      expect(subject.description).to eq("")
      expect(subject.images).to eq({})
      expect(subject.amenities).to eq({})
    end
  end

  describe '.id' do
    let(:data) { { 'Id' => 'aafd' } }
    it { expect(subject.id).to eq('aafd') }
  end

  describe '.destination_id' do
    let(:data) { { 'DestinationId' => 'asdfg' } }
    it { expect(subject.destination_id).to eq('asdfg') }
  end

  describe '.name' do
    let(:data) { { 'Name' => 'Nikko' } }
    it { expect(subject.name).to eq('Nikko') }
  end

  describe '.latitude' do
    let(:data) { { 'Latitude' => '25323' } }
    it { expect(subject.latitude).to eq('25323') }
  end

  describe '.longtitude' do
    let(:data) { { 'Longitude' => '63243' } }
    it { expect(subject.longtitude).to eq('63243') }
  end

  describe '.city' do
    let(:data) { { 'City' => 'HCM' } }
    it { expect(subject.city).to eq('HCM') }
  end

  describe '.country' do
    let(:data) { { 'Country' => 'Viet Name' } }
    it { expect(subject.country).to eq('Viet Name') }
  end

  describe '.postal_code' do
    let(:data) { { 'PostalCode' => '70000' } }
    it { expect(subject.postal_code).to eq('70000') }
  end

  describe '.description' do
    let(:data) { { 'Description' => 'my description' } }
    it { expect(subject.description).to eq('my description') }
  end
end
