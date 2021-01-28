module ExecutorEnvironment
  AVAILABLE = [
    ExecutorEnvironment::Bash,
    ExecutorEnvironment::Cobol,
    ExecutorEnvironment::Javascript,
    ExecutorEnvironment::Php,
    ExecutorEnvironment::Ruby,
  ]

  def self.find_by_language(language)
    AVAILABLE.find { |env|
      env::LANGUAGE == language
    }
  end

  def self.build_all_images
    AVAILABLE.each(&:build_image)
  end
end
