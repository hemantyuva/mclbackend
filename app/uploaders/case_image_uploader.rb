# encoding: utf-8
class CaseImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::Video
  # include CarrierWave::FFmpeg
  include CarrierWave::Video::Thumbnailer

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end


  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :case_video, :if => :video? do
    process :encode
  end

  def encode
    video = FFMPEG::Movie.new(@file.path)
    video_transcode = video.transcode(@file.path)
  end

  # Create different versions of your uploaded files:
  version :case_image,:if => :image? do
    process :resize_to_fit => [740, 300]
  end

  # Create different versions of your uploaded files:
  version :thumb,:if => :image? do
    process :resize_to_fit => [100, 100]
  end
  
  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def whitelist_mime_type_pattern
  #   %w(jpg jpeg gif png mp4 m4v mov avi mkv mp3 wav)
  # end
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

 protected
    def image?(new_file)
      new_file.content_type.include? 'image'
    end
    
    def video?(new_file)
      new_file.content_type.include? 'video'
    end
end
