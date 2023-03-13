def authenticate_with_token(token)
  ActionController::HttpAuthentication::Token.encode_credentials(token)
end

def response_json
  JSON.parse(response.body)
end
