module KcAndroidPublishUploader
  
  class ApkUploader
    attr_accessor :filename, :url

    def self.store!(filename, file)
    end

    def self.find(filename)
    end

  end
end


#apk_upload = ApkUploader.store!(filename, file)
#apk_upload = ApkUploader.find(filename)

# apk_upload.filename
# apk_upload.url