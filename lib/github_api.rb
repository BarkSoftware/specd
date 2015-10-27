class GithubApi
  def initialize token
    @token = token
  end

  attr_reader :token
  attr_accessor :response

  def get url
    @response = conn.get url
    JSON.parse(response.body, symbolize_names: true).tap do |result|
      if result.kind_of?(Array)
        page_to_end_of_results result
      end
    end
  end

  def put url, data = {}
    @response = conn.put url do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = data.to_json
    end
    json_response
  end

  def patch url, data
    @response = conn.patch url do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = data.to_json
    end
    json_response
  end

  def post url, data
    @response = conn.post url do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = data.to_json
    end
    json_response
  end

  def delete url
    @response = conn.delete url
    json_response
  end

  private

  def json_response
    JSON.parse(response.body, symbolize_names: true) if response.body.present?
  end

  def conn
    Faraday.new.tap do |conn|
      conn.basic_auth(token, 'x-oauth-basic')
    end
  end

  def page_to_end_of_results current_results
    if response.headers['link']
      next_link = ::LinkHeader.parse(response.headers['link']).find_link ['rel', 'next']
      if next_link
        current_results.push(*(get(next_link.to_a[0])))
      end
    end
  end
end
