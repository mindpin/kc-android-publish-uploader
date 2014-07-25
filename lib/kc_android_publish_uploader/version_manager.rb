module KcAndroidPublishUploader

  class VersionManager

    def self.file_path(platform)
      File.expand_path("../../../config/#{platform}.yaml", __FILE__)
      # File.dirname(__FILE__) + '/' + platform + '.yaml'
    end


    def self.init_yaml(file)
      begin
        YAML.load(File.read(file))
      rescue
      end
    end

    def self.add_version(platform, version, is_milestone, changelog)
      file = file_path(platform)

      current_platform_versions = get_platform_versions(platform)

      return if current_platform_versions.nil?

      version = version.to_s
      is_milestone = is_milestone.to_s
      changelog = changelog.to_s

      # 确保参数不能为空
      return if empty_params?(version, is_milestone, changelog)

      # is_milestone 必须是true false
      return if !is_milestone_boolean?(is_milestone)

      data = new_data = [{
        'version' => version, 
        'is_milestone' => is_milestone,
        'changelog' => changelog
      }]

      # 需要if的原因是如果是空文件的话会报错
      if current_platform_versions

        # version 验证
        current_first_version = current_platform_versions.first['version']
        if !first_verion_more_than_second?(version, current_first_version)
          # p "请检查version #{version}"
          return
        end


        current_platform_versions.each do |d| 
          if d.invert[version]
            # p "#{platform} version #{version} 已经存在"
            return nil
          end
        end
        data = new_data + current_platform_versions
      end

      File.open(file, 'w') {|f| f.write(data.to_yaml) }
    end

    def self.get_newest_version(platform)
      current_platform_versions = get_platform_versions(platform)
      current_platform_versions.first['version'] if current_platform_versions
    end

    def self.get_newest_milestone_version(platform)
      current_platform_versions = get_platform_versions(platform)

      return if !current_platform_versions

      current_platform_versions.each do |d|
        return d['version'] if d['is_milestone'].to_s.eql?('true')
      end

      nil

    end

    def self.get_changelog(platform, version)
      current_platform_versions = get_platform_versions(platform)

      return if !current_platform_versions

      current_platform_versions.each do |d|
        return d['changelog'] if d.invert[version]
      end
      
    end



    private
      def self.is_correct_platform?(platform)
        return true if platform.eql?('android') || platform.eql?('ios')
          
        # p "platform #{platform} 错误"
        false
      end

      def self.file_exists?(file)
        return true if File.exists?(file)

        # p '文件无法找到'
        false
      end

      def self.empty_params?(version, is_milestone, changelog)
        if version.empty? || is_milestone.empty? || changelog.empty?
          # p 'version, is_milestone, changelog 参数不能为空'
          return true
        end
        false
      end


      def self.is_milestone_boolean?(is_milestone)
        return true if is_milestone.eql?('true') || is_milestone.eql?('false')

        # p 'is_milestone 必须为true 或者 false 中的一个值'
        false
      end


      def self.get_platform_versions(platform)

        file = file_path(platform)
   
        # 检查平台是否为 android, ios
        return nil if !is_correct_platform?(platform)

        # 确保文件存在
        File.open(file, 'w+') {|f| f.write('') } if !file_exists?(file)

        init_yaml(file)
      end


      def self.first_verion_more_than_second?(first_version, second_version)
        return false if !is_version_format_correct?(first_version)
        return false if !is_version_format_correct?(second_version)

        first_version = first_version.split('.')
        second_version = second_version.split('.')

        first_version.map! { |v| v.to_i }
        second_version.map! { |v| v.to_i }

        return first_version[0] > second_version[0] if first_version[0] != second_version[0]
        return first_version[1] > second_version[1] if first_version[1] != second_version[1]
        
        first_version[2] > second_version[2]

      end


      def self.is_version_format_correct?(version)
        return true if version =~ /^[0-9]+[\.][0-9]+[\.][0-9]+$/

        # p "非法的 version #{version}"
        return false
      end


  end

end