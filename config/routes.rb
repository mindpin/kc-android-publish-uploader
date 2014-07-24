KcAndroidPublishUploader::Engine.routes.draw do
  get '/' => 'index#index'

  get "/download/android/4ye-:version.apk" => "index#download"

  post "/check_version" => "index#check_version"

  post "/publish" => "index#publish"

  post "/submit_exception" => "index#submit_exception"

  post "/submit_feedback"  => "index#submit_feedback"
end