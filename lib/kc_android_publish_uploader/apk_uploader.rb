module KcAndroidPublishUploader
  
  class ApkUploader
    attr_accessor :filename, :url

    def self.store!(filename, file)
      apk_uploader = self.new(filename)
      apk_uploader.store!(file)
    end

    def self.find(filename)
      self.new(filename)
    end

    def initialize(filename)
      @filename = filename
      @oss_object = _oss_object
      @url = @oss_object.url
    end

    def store!(file)
      @oss_object.upload(file)
    end

    ##########
    def _oss_object
      self.class._get_aliyun_oss_bucket.object(_path)
    end

    def _path
      "/kc-android/#{filename}"
    end

    def self._get_aliyun_oss_service
      @@aliyun_oss_service ||= Aliyun::Service.new(
        :access_key_id => RUtil.get_aliyun_oss_access_key_id,
        :access_key_secret => RUtil.get_aliyun_oss_access_key_secret,
        :host => RUtil.get_aliyun_oss_host
      )
    end

    def self._get_aliyun_oss_bucket
      @@aliyun_oss_bucket ||= _get_aliyun_oss_service.bucket(RUtil.get_aliyun_oss_bucket_name)
    end

  end
end


#apk_upload = ApkUploader.store!(filename, file)
#apk_upload = ApkUploader.find(filename)

# apk_upload.filename
# apk_upload.url