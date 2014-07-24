module KcAndroidPublishUploader
  
  class MobileFeedBack
    EXCEPTION = "EXCEPTION"
    FEEDBACK  = "FEEDBACK"

    include Mongoid::Document
    include Mongoid::Timestamps

    field :version,            :type => String
    field :datetime,           :type => DateTime
    field :user_id,            :type => Integer
    field :device_name,        :type => String
    field :sdk_version,        :type => String
    field :os_release_version, :type => String
    field :other_device_info,  :type => Hash
    field :kind,               :type => String
    field :exception_type,     :type => String
    field :exception_stack,    :type => String
    field :feedback,           :type => String

    validates :kind, :version, :datetime, :user_id,
              :device_name, :sdk_version, :os_release_version,
              :presence => true

    def self.from_params(params)
      self.new(params)
    end

    def is_exception?
      self.exception_type && self.exception_stack
    end

    def is_feedback?
      self.feedback
    end

    def set_kind!
      return self.kind = EXCEPTION if is_feedback?
      return self.kind = FEEDBACK if is_exception?
      self.kind = nil
    end
  end

end
