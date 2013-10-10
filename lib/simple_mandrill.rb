require 'json'
require 'net/http'
require 'uri'

class SimpleMandrill

  class MandrillError < RuntimeError
    attr_reader :status, :code, :name, :message

    def initialize(status, code, name, message)
      super(message)

      @status = status
      @code = code
      @name = name
      @message = message
    end
  end

  def initialize(api_key)
    @api_key = api_key
    freeze
  end

  def users_info
    call :users, :info
  end

  def messages_send(message)
    call :messages, :send, message: message
  end

  private

  def call(group, action, body = {})
    make_request(:post, endpoint_url(group, action), body)
  end

  def endpoint_url(group, action)
    "https://mandrillapp.com/api/1.0/#{group}/#{action}.json"
  end

  def wrap_exception(e)
    if e.respond_to?(:response)
      json = JSON.parse(e.response.body)
      MandrillError.new(json['status'], json['code'], json['name'], json['message'])
    else
      MandrillError.new("failure", -1, "Communication", e.message)
    end
  end

  def make_request(request_type, url, body = nil)
    uri = URI(url)

    request_class = case request_type
                    when :get
                      Net::HTTP::Get
                    when :put
                      Net::HTTP::Put
                    when :post
                      Net::HTTP::Post
    end

    response = nil
    response_json = nil

    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = request_class.new(uri.path)
      request.body = JSON.pretty_generate(body.merge(key: @api_key)) if body
      response = http.request(request)

      response_json = JSON.parse(response.body)
    rescue RuntimeError => e
      raise MandrillError.new("failure", -1, "Communication", e.message)
    ensure
      http.finish if http && http.started?
    end

    unless response.code == "200"
      raise MandrillError.new(response_json['status'], response_json['code'], response_json['name'], response_json['message'])
    end

    response_json
  end

end
