module ExecutorEnvironment
  module Ruby
    extend Base

    LANGUAGE = "ruby"
    VERSION = "3.0.0"

    SCRIPT_PATH = "/script.rb"

    DOCKERFILE_DIR = File.join(__dir__, LANGUAGE)
    DOCKERFILE_ARGS = {
      LANGUAGE: LANGUAGE,
      VERSION: VERSION,
    }
  end
end
