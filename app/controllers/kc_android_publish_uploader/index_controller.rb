module KcAndroidPublishUploader
  class IndexController < ApplicationController
    def download
      version = get_version(params)
      if !version
        return render :text => 404, :status => 404
      end
      uploader = ApkUploader.find("kc-android-#{version}.apk")
      redirect_to uploader.url
    end

    def check_version
      render :json => VersionGetter.new(params).response
    end

    def publish
      render :json => VersionUpdater.new(params).response
    end

    def submit_exception
      if params[:feedback]
        return render :text => 406, :status => 406
      end
      render :text => MobileFeedBackSaver.new(params).response
    end

    def submit_feedback
      if params[:exception_type] || params[:exception_stack]
        return render :text => 406, :status => 406
      end
      MobileFeedBackSaver.new(params).response
    end

    protected

    def get_version(params)
      if params[:version] == "newest"
        VersionManager.get_newest_version("android")
      else params[:version]
        params[:version]
      end
    end

  end
end