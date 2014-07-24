module KcAndroidPublishUploader
  
  class VersionGetter
    UPDATE = {:force => 'force', :exist => 'exist', :none => 'none'}
    PLATFORM = {:android => 'android', :ios => 'ios'}

    attr_reader :version, :newest, :last_milestone, :update, :platform

    def initialize(params)
      @platform = PLATFORM[:android]
      @version = params[:version]
      @newest = VersionManager.get_newest_version(@platform)
      @last_milestone = VersionManager.get_newest_milestone_version(@platform)
      @update = _update
    end

    def response
      hash = {
        :newest         => @newest,
        :last_milestone => @last_milestone,
        :current        => @version,
        :update         => @update
      }
      JSON.generate(hash)
    end

    private
      def _update
        return UPDATE[:none] if @version == @newest || @newest.nil?

        return UPDATE[:force] if VersionManager.first_verion_more_than_second?(@last_milestone, @version || "0.0.0") 

        UPDATE[:exist]
      end
  end

end