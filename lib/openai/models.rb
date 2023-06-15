module OpenAI
  class Models
    def initialize(client: nil)
      @client = client
    end

    def list
      @client.get(path: "/models")
    end

    def retrieve(id:)
      @client.get(path: "/models/#{id}")
    end
  end
end
