CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAZMSM2OLSXWTY4VGF',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }
  
    config.fog_directory  = 'teamcare-images'
    config.asset_host = "https://s3.ap-northeast-1.amazonaws.com/teamcare-images"
    config.fog_public = false
    config.cache_storage = :fog
end