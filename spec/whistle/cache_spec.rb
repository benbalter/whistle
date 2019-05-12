RSpec.describe Whistle::Cache do
  let(:memory) { subject.instance_variable_get '@memory' }

  it 'sets' do
    subject.set('foo', 'bar')
    expect(memory).to have_key('foo')
    expect(memory['foo']).to eql('bar')
  end

  it 'gets' do
    subject.instance_variable_set('@memory', 'foo' => 'bar')
    expect(subject.get('foo')).to eql('bar')
  end
end
