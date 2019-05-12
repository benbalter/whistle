module Whistle
  class Client
    attr_accessor :email, :password, :pet_id
    attr_writer :token

    def initialize(token: nil, email: nil, password: nil, pet_id: nil)
      @token    = token    || ENV['WHISTLE_TOKEN']
      @email    = email    || ENV['WHISTLE_EMAIL']
      @password = password || ENV['WHISTLE_PASSWORD']
      @pet_id   = pet_id   || ENV['WHISTLE_PET_ID']
    end

    def token
      return @token if @token

      creds = { email: email, password: password }
      args = { body: creds.to_json, method: :post }
      data = request('login', args)
      @token = data['auth_token']
    end

    def pets
      @pets ||= request('pets')['pets'].map { |p| Pet.new(p, client: self) }
    end

    def pet(pet_id = nil)
      pet_id ||= default_pet.id
      Pet.new request("pets/#{pet_id}")['pet'], client: self
    end

    def request(path, args = {})
      args = request_args(path, args)
      uri = BASE.join(path)

      Whistle.logger.info "Requesting #{uri}"
      response = Typhoeus::Request.new(uri, args).run
      raise BadResponse, response.code unless response.success?

      JSON.parse(response.body)
    end

    private

    def default_pet
      @default_pet ||= if pet_id
                         Pet.new({ id: pet_id }, client: self)
                       else
                         pets.first
                       end
    end

    def request_args(path, args)
      args = DEFAULT_TYPHOEUS_ARGS.merge(args)

      unless path == 'login'
        args[:headers] = args[:headers].merge(
          "Authorization": "Bearer #{token}"
        )
      end

      args
    end
  end
end
