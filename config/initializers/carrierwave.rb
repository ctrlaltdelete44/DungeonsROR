CarrierWave.configure do |config|
 
    # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.cache_dir = "#{Rails.root}/tmp/test_uploads"
  else
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['S3_KEY'],                        # required unless using use_iam_profile
      aws_secret_access_key: ENV['S3_SECRET'],                        # required unless using use_iam_profile
      use_iam_profile:       false,                         # optional, defaults to false
      region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
      host:                  's3.amazonaws.com',             # optional, defaults to nil
    #   endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = ENV['S3_BUCKET_NAME']                                      # required
    config.fog_public     = false                                                 # optional, defaults to true
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
    config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku
    config.storage = :fog
  end


end

