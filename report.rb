require "honeybadger-api"

access_token = "xxx"

Honeybadger::Api.configure do |c|
  c.access_token = access_token
end


project_id = "1404"
project = Honeybadger::Api::Project.find(project_id)