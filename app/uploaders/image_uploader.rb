class ImageUploader < CarrierWave::Uploader::Base  

  # リサイズしたり画像形式を変更するのに必要
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
 
  #サムネイルの為に画像をリサイズ
  version :thumb do 
  process resize_to_fit: [200, 200] 
  end 
  version :thumb50 do 
  process resize_to_fit: [100, 100] 
  end  

  def default_url(*args)
    # # For Rails 3.1+ asset pipeline compatibility:
    # # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "default.jpg"
    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    end
end
