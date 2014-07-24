module KcAndroidPublishUploader
  class IndexController < ApplicationController
    def download
      version = get_version(params)
      return 404 if !version
      uploader = ApkUploader.find("4ye-#{version}.apk")
      redirect_to uploader.url
    end

    def check_version
      VersionGetter.new(params).response
    end

    def publish
      VersionUpdater.new(params).response
    end

    def submit_exception
      return 406 if params[:feedback]
      MobileFeedBackSaver.new(params).response
    end

    def submit_feedback
      return 406 if params[:exception_type] || params[:exception_stack]
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