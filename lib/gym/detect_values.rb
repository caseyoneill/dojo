module Gym
  # This class detects all kinds of default values
  class DetectValues
    # This is needed as these are more complex default values
    # Returns the finished config object
    def self.set_additional_default_values
      config = Gym.config

      FastlaneCore::Project.detect_projects(config)

      Gym.project = FastlaneCore::Project.new(config)
      detect_provisioning_profile

      # Go into the project's folder
      Dir.chdir(File.expand_path("..", Gym.project.path)) do
        config.load_configuration_file(Gym.gymfile_name)
      end

      config[:use_legacy_build_api] = true if Xcode.pre_7?

      detect_scheme
      detect_platform # we can only do that *after* we have the scheme
      detect_configuration

      config[:output_name] ||= Gym.project.app_name

      # we do it here, since the value is optional and should be pre-filled by fastlane if necessary
      config[:export_method] ||= "app-store"

      return config
    end

    # Helper Methods

    def self.detect_provisioning_profile
      unless Gym.config[:provisioning_profile_path]
        Dir.chdir(File.expand_path("..", Gym.project.path)) do
          profiles = Dir["*.mobileprovision"]
          if profiles.count == 1
            profile = File.expand_path(profiles.last)
          elsif profiles.count > 1
            puts "Found more than one provisioning profile in the project directory:"
            profile = choose(*(profiles))
          end

          Gym.config[:provisioning_profile_path] = profile
        end
      end

      if Gym.config[:provisioning_profile_path]
        FastlaneCore::ProvisioningProfile.install(Gym.config[:provisioning_profile_path])
      end
    end

    def self.detect_scheme
      Gym.project.select_scheme
    end

    # Is it an iOS device or a Mac?
    def self.detect_platform
      return if Gym.config[:destination]
      platform = Gym.project.mac? ? "OS X" : "iOS" # either `iOS` or `OS X`

      Gym.config[:destination] = "generic/platform=#{platform}"
    end

    # Detects the available configurations (e.g. Debug, Release)
    def self.detect_configuration
      config = Gym.config
      configurations = Gym.project.configurations
      return if configurations.count == 0 # this is an optional value anyway

      if config[:configuration]
        # Verify the configuration is available
        unless configurations.include?(config[:configuration])
          Helper.log.error "Couldn't find specified configuration '#{config[:configuration]}'.".red
          config[:configuration] = nil
        end
      end
    end
  end
end
