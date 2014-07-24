module KcAndroidPublishUploader

  class MobileFeedBackSaver
    attr_reader :params

    def initialize(params)
      @params = parse(params)
    end

    def response
      persist! ? "" : 406
    end

    private

    def parse(params)
      hash = params.dup
      hash[:datetime] = Time.at(hash[:datetime].to_i)
      hash[:other_device_info] = hash[:other_device_info] && JSON.parse(hash[:other_device_info])
      hash[:kind] = nil
      hash
    end

    def persist!
      model = MobileFeedBack.from_params(params)
      model.set_kind!
      model.save
    end
  end
  
end