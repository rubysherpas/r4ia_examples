require "nokogiri"

class LinkJumbler
  def initialize(app, letters)
    @app = app
    @letters = letters
  end

  def call(env)
    status, headers, response = @app.call(env)
    if headers['Content-Type'].include?("text/html")
      body = Nokogiri::HTML(response.body)
      body.css("a").each do |a|
        @letters.each do |find, replace|
          a.content = a.content.gsub(find.to_s, replace.to_s)
        end
      end
    else
      body = response.body
    end

    [status, headers, Rack::Response.new(body.to_s)]
  end
end
