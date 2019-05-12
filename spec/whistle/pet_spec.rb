RSpec.describe Whistle::Pet do
  before do
    Timecop.freeze(Time.local(2020))
  end

  after do
    Timecop.return
  end

  let(:id) { 1 }
  let(:client) { Whistle::Client.new(token: 'auth_token') }
  let(:data) { { id: id } }
  let(:start) { Time.parse('2020-01-01 09:00:00Z') }
  let(:current_location) do
    {
      start: start,
      end: nil,
      type: :inside,
      data: {}
    }
  end
  subject { described_class.new(data, client: client) }

  before do
    stub_request(:get, 'https://app.whistle.com/api/pets/1/timelines/location')
      .to_return(status: 200, body: fixture_contents('location.json'))
  end

  it 'returns the timeline' do
    expect(subject.timeline).to be_an(Array)
    expect(subject.timeline.first).to be_a(Whistle::TimelineEntry)
    expect(subject.timeline.first).to eql(current_location)
  end

  it 'returns the current location' do
    expect(subject.current_location).to eql(current_location)
  end

  it 'returns the time inside' do
    expect(subject.time_inside).to eql(start)
  end

  it 'humanizes the time inside' do
    expect(subject.time_inside(humanize: true)).to eql('about 4 hours')
  end
end
