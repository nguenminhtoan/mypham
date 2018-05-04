require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyPhamOnline
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    
    config.db_host = "ec2-107-21-103-146.compute-1.amazonaws.com"
    config.db_user = "auszbnehasmxfn"
    config.db_pass = "5ffd8f8225cf71d02c3dad0e9999e249fe4548d286c2fe1837a11909e3098ebf"
    config.db_schema = "d5ei310sp8to6d"
    
    
    
    config.format_msg = "không đúng định dạng"
    config.blank_msg = "không được trống"

  end
end
