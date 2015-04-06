require "httparty"

token = "YOUR_TOKEN_GOES_HERE"
url = "http://localhost:3000/api/projects/1/tickets/1.json"

response = HTTParty.get(url,
  headers: {
    "Authorization" => "Token token=#{token}"
  }
)

puts response.parsed_response
