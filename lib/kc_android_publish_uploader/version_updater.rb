module KcAndroidPublishUploader

  class VersionUpdater
    PLATFORM = "android"

    attr_reader :package, :version, :is_milestone
    attr_reader :size, :error, :current

    def initialize(params = {})
      params.keys.each do |key|
        self.instance_variable_set :"@#{key}", params[key]
      end
      case @is_milestone
      when "true" then @is_milestone = true
      else false
      end
    end

    def save_file!
      @size = package[:tempfile].size
      ApkUploader.store!("4ye-#{version}.apk", package[:tempfile])
      true
    end

    def valid?
      @error = "low version" if !version_valid?
      @error = "no package provided" if !package
      package && version_valid?
    end

    def version_valid?
      @current = VersionManager.get_newest_version(PLATFORM)
      is_higher = version_compare(current || "0.0.0", version) == -1 
      version && version.match(/(\d+\.){2}\d+/) && is_higher
    end

    def version_compare(version1, version2)
      v1 = split_version(version1)
      v2 = split_version(version2)
      first  = v1[0] <=> v2[0]
      second = v1[1] <=> v2[1]
      third  = v1[2] <=> v2[2]
      return first  if first  != 0
      return second if second != 0
      third
    end

    def split_version(version)
      version.split(".").map(&:to_i)
    end

    def response
      run! ? success : failure
    end

    private

    def latest_milestone
      VersionManager.get_newest_milestone_version(PLATFORM)
    end

    def run!
      return false if !valid?
      if !save_file!
        @error = "file not saved"
        return false
      end
      VersionManager.add_version(PLATFORM, version, !!is_milestone, "...")
      true
    rescue Exception => e 
      @error = "other"
      puts e
      puts e.backtrace
      false
    end

    def success
      JSON.generate({
        :status => "success",
        :newest_version => version,
        :newest_milestone => latest_milestone,
        :package_size => size
      })
    end

    def failure
      JSON.generate({
        :status => error,
        :newest_version => current,
        :newest_milestone => latest_milestone
      })
    end
  end

end