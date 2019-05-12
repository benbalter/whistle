RSpec.describe Whistle::TimelineEntry do
  before do
    Timecop.freeze(Time.local(2020))
  end

  after do
    Timecop.return
  end

  let(:start_time) { Time.now - 60 * 5 }
  let(:end_time) {}
  let(:type) {}
  let(:data) { {} }
  let(:hash) do
    { start: start_time, end: end_time, type: type, data: data }
  end

  subject { described_class.new(hash) }

  context 'inside' do
    let(:type) { 'inside' }

    it "knows it's inside" do
      expect(subject).to be_inside
    end

    it "knows it's not outside" do
      expect(subject).to_not be_outside
    end
  end

  context 'outside' do
    let(:type) { 'outside' }

    it "knows it's outside" do
      expect(subject).to be_outside
    end

    it "knows it's not inside" do
      expect(subject).to_not be_inside
    end
  end

  it 'returns the start time' do
    expect(subject.start).to eql(start_time)
  end

  it 'returns the end time' do
    expect(subject.end).to eql(end_time)
  end

  it 'returns the type' do
    expect(subject.type).to eql(type)
  end

  it 'returns the data' do
    expect(subject.data).to eql(data)
  end

  it 'returns the start_time_ago_in_words' do
    expect(subject.start_time_ago_in_words).to eql('5 minutes')
  end
end
