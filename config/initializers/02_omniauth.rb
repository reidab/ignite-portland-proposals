OmniAuth.config.path_prefix = OpenConferenceWare.mounted_path("auth")

Rails.application.config.middleware.use OpenConferenceWare::OmniAuthBuilder do
  # Configure authentication providers for OpenConferenceWare

  # The providers below are supported with built-in sign in forms.
  #
  # Additional providers can be found at:
  #   https://github.com/intridea/omniauth/wiki/List-of-Strategies
  #
  # When adding a new provider, it will be linked to from the sign in page.
  #
  # If you want to display a nicer form, just add a partial at
  # /app/views/open_conference_ware/authentications/_<provider>.html.erb
  #
  # Providers will be shown on the sign in page in the order they are added.

  secrets = {}
  secrets_file = Rails.root.join('config', 'secrets.yml')
  if File.exists?(secrets_file)
    secrets = YAML.load_file(secrets_file)
  else
    raise "Oops, config/secrets.yml could not be found."
  end

  # OpenID
  # add 'omniauth-openid' to Gemfile and uncomment to enable OpenID
  #
  require 'openid/store/filesystem'
  provider :openid, store: OpenID::Store::Filesystem.new(Rails.root.join('tmp'))

  # Twitter
  if secrets.has_key?("twitter_key")
    provider :twitter, secrets["twitter_key"], secrets["twitter_secret"]
  end

  # GitHub
  if secrets.has_key?("github_key")
    provider :github, secrets["github_key"], secrets["github_secret"]
  end

  # Google
  if secrets.has_key?("google_key")
    provider :google_oauth2, secrets["google_key"], secrets["google_secret"]
  end

  # Persona
  # add 'omniauth-persona' to Gemfile and uncomment to enable Persona
  #
  provider :persona

  # Developer
  # Used to provide easy authentication during development
  provider :developer if %w[development preview].include?(Rails.env)
end
