RSpec.describe Whistle::Client do
  let(:token) {}
  let(:email) {}
  let(:password) {}
  let(:pet_id) {}

  subject do
    described_class.new(
      token: token,
      email: email,
      password: password,
      pet_id: pet_id
    )
  end

  before do
    ENV.each do |k, _v|
      ENV[k] = nil if k =~ /^WHISTLE_/
    end
  end

  context 'with an email and passowrd' do
    let(:email) { 'foo@example.com' }
    let(:password) { 'password' }

    it 'stores the email and password' do
      expect(subject.email).to eql(email)
      expect(subject.password).to eql(password)
    end

    it 'gets the token' do
      body = {
        email: email,
        password: password
      }.to_json
      stub_request(:post, 'https://app.whistle.com/api/login')
        .with(body: body, headers: {
                'Accept' => 'application/vnd.whistle.com.v4+json',
                'Content-Type' => 'application/json',
                'Expect' => '',
                'User-Agent' => 'Typhoeus - https://github.com/typhoeus/typhoeus'
              })
        .to_return(status: 200, body: fixture_contents('login.json'))

      expect(subject.token).to eql('auth_token')
    end
  end

  context 'with a token' do
    let(:token) { 'auth_token' }

    it 'gets pets' do
      stub_request(:get, 'https://app.whistle.com/api/pets')
        .to_return(status: 200, body: fixture_contents('pets.json'))

      expect(subject.pets).to eql([{ 'id' => 1, 'name' => 'Fido' }])
    end

    it 'gets a pet by id' do
      stub_request(:get, 'https://app.whistle.com/api/pets/1')
        .to_return(status: 200, body: fixture_contents('pet.json'))
      expect(subject.pet(1)).to eql('id' => 1, 'name' => 'Fido')
    end

    context 'with a pet_id' do
      let(:pet_id) { 1 }

      it 'gets the pet_id pet' do
        stub_request(:get, 'https://app.whistle.com/api/pets/1')
          .to_return(status: 200, body: fixture_contents('pet.json'))
        expect(subject.pet).to eql('id' => 1, 'name' => 'Fido')
      end
    end

    context 'without a pet_id' do
      it 'gets the first pet' do
        stub_request(:get, 'https://app.whistle.com/api/pets')
          .to_return(status: 200, body: fixture_contents('pets.json'))

        stub_request(:get, 'https://app.whistle.com/api/pets/1')
          .to_return(status: 200, body: fixture_contents('pet.json'))

        expect(subject.pet).to eql('id' => 1, 'name' => 'Fido')
      end
    end

    it 'makes requests' do
      request = stub_request(:get, 'https://app.whistle.com/api/foo')
                .with(headers: {
                        'Accept' => 'application/vnd.whistle.com.v4+json',
                        'Authorization' => 'Bearer auth_token',
                        'Content-Type' => 'application/json',
                        'Expect' => '',
                        'User-Agent' => 'Typhoeus - https://github.com/typhoeus/typhoeus'
                      }).to_return(status: 200, body: '{}')

      subject.request('foo')
      expect(request).to have_been_requested
    end
  end
end
