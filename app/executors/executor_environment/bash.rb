module ExecutorEnvironment
  module Bash
    extend Base

    LANGUAGE = "bash"
    VERSION = "5.1.0"

    SCRIPT_PATH = "/script.sh"

    DOCKERFILE_DIR = File.join(__dir__, LANGUAGE)
    DOCKERFILE_ARGS = {
      LANGUAGE: LANGUAGE,
      VERSION: VERSION,
    }
  end
end
