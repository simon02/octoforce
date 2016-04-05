SuperfeedrEngine::Engine.feed_class = "Feed" # Use the class you use for feeds. (Its name as a string)
# This class needs to have the following attributes/methods:
# * url: should be the main feed url
# * id: a unique id (string) for each feed (can be the primary index in your relational table)
# * secret: a secret which should never change and be unique for each feed. It must be hard to guess. (a md5 or sha1 string works fine!)

SuperfeedrEngine::Engine.base_path = "/superfeedr_engine/" # Base path for the engine don't forget the trailing /

SuperfeedrEngine::Engine.host = ENV['SUPERFEEDR_URL'] || "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" # Your hostname (no http). Used for webhooks!
# When debugging, you can use tools like https://www.runscope.com/docs/passageway to
# share your local web server with superfeedr's API via a public URL

SuperfeedrEngine::Engine.login = "octoforce" # Superfeedr username

SuperfeedrEngine::Engine.password = "51a6a8d5386f1d23732e3ab2b25f210a" # Token value
# make sure it has the associated rights you need (subscribe,unsubscribe,retrieve,list)

SuperfeedrEngine::Engine.scheme = "http" # Can use HTTPS or a different port with SuperfeedrEngine::Engine.port
