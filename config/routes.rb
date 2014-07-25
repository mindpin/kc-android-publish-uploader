KcAndroidPublishUploader::Engine.routes.draw do
  get '/' => 'index#index'

  get "/download/android/kc-android-:version.apk" => "index#download",
   :constraints => {:version => /[0-9a-zA-Z]\.[0-9a-zA-Z]\.[0-9a-zA-Z]/}

  post "/check_version" => "index#check_version"

  post "/publish" => "index#publish"

  post "/submit_exception" => "index#submit_exception"

  post "/submit_feedback"  => "index#submit_feedback"
end