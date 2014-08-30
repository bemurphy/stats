require "cuba"
require "cuba/contrib"
require "moped"
require "mote"
require "ohm"
require "ohm/contrib"
require "rack/protection"
require "scrivener"
require "scrivener_errors"
require "shield"

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::Prelude
Cuba.plugin ScrivenerErrors::Helpers
Cuba.plugin Shield::Helpers

# Require all application files.
Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

# Require all helper files.
Dir["./helpers/**/*.rb"].each { |rb| require rb }
Dir["./filters/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::MethodOverride
Cuba.use Rack::Session::Cookie,
  key: "my_new_app",
  secret: ENV.fetch("SESSION_SECRET")

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  root: "./public",
  urls: %w[/js /css /img]

Cuba.define do
  persist_session!

  on get, "track" do
    id   = req.params['id']
    time = Time.now.utc
    # r = rand(0)
    # if r < 0.3
    #   time -= 3601
    # elsif r > 0.7
    #   time += 3601
    # end

    unique = rand(0) < 0.3

    hit = Stats::Hit.new(time, id, unique)
    hit.record

    res.write "ok"
  end

  on root do
    render('index')
  end
end
