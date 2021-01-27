module ExecutorEnvironment
  module Php
    extend Base

    LANGUAGE = "php"
    VERSION = "8.0.1"

    SCRIPT_PATH = "/script.php"

    DOCKERFILE_DIR = File.join(__dir__, LANGUAGE)
    DOCKERFILE_ARGS = {
      LANGUAGE: LANGUAGE,
      VERSION: VERSION,
    }
  end
end
