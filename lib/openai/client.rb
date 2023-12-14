module OpenAI
  class Client
    attr_reader :access_token, :organization_id, :uri_base, :request_timeout

    def initialize(
      access_token: nil, organization_id: nil, uri_base: nil,
      request_timeout: nil, api_type: nil, api_version: nil
    )
      @access_token = access_token || OpenAI.configuration.access_token
      @organization_id = organization_id || OpenAI.configuration.organization_id
      @uri_base = uri_base || OpenAI.configuration.uri_base
      @request_timeout = request_timeout || OpenAI.configuration.request_timeout
      @api_type = api_type
      @api_version = api_version || OpenAI.configuration.api_version
    end

    def chat(parameters: {})
      json_post(path: "/chat/completions", parameters: parameters)
    end

    def completions(parameters: {})
      json_post(path: "/completions", parameters: parameters)
    end

    def edits(parameters: {})
      json_post(path: "/edits", parameters: parameters)
    end

    def embeddings(parameters: {})
      json_post(path: "/embeddings", parameters: parameters)
    end

    def files
      @files ||= OpenAI::Files.new(client: self)
    end

    def finetunes
      @finetunes ||= OpenAI::Finetunes.new(client: self)
    end

    def images
      @images ||= OpenAI::Images.new(client: self)
    end

    def models
      @models ||= OpenAI::Models.new(client: self)
    end

    def moderations(parameters: {})
      json_post(path: "/moderations", parameters: parameters)
    end

    def transcribe(parameters: {})
      multipart_post(path: "/audio/transcriptions", parameters: parameters)
    end

    def translate(parameters: {})
      multipart_post(path: "/audio/translations", parameters: parameters)
    end

    def get(path:)
      conn.get(uri(path: path)) do |req|
        req.headers = headers
      end
    end

    def json_post(path:, parameters:)
      conn.post(uri(path: path)) do |req|
        req.headers = headers
        if parameters[:stream] && parameters[:on_data].is_a?(Proc)
          req.options.on_data = parameters[:on_data]
        end
        parameters.delete(:on_data)
        req.body = parameters.to_json
      end
    end

    def multipart_post(path:, parameters: nil)
      conn.post(uri(path: path)) do |req|
        req.body = parameters
        req.headers = headers.merge({ "Content-Type" => "multipart/form-data" })
      end
    end

    def delete(path:)
      conn.delete(uri(path: path)) do |req|
        req.headers = headers
      end
    end

    private

    def conn
      @conn ||= Faraday.new(params: nil, request: { timeout: request_timeout }) do |connection|
        connection.response :raise_error
      end
    end

    def uri(path:)
      if azure?
        base = File.join(@uri_base, path)
        "#{base}?api-version=#{@api_version}"
      else
        File.join(@uri_base, @api_version, path)
      end
    end

    def headers
      if azure?
        azure_headers
      else
        openai_headers
      end
    end

    def openai_headers
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@access_token}",
        "OpenAI-Organization" => @organization_id
      }
    end

    def azure_headers
      {
        "Content-Type" => "application/json",
        "api-key" => @access_token
      }
    end

    def azure?
      @api_type&.to_sym == :azure
    end
  end
end
