RSpec.describe Whistle do
  it 'has a version number' do
    expect(Whistle::VERSION).to_not be_nil
  end

  it 'returns the client' do
    expect(subject.client).to be_a(Whistle::Client)
  end

  it 'returns the logger' do
    expect(subject.logger).to be_a(Logger)
  end
end
