module ExecutorEnvironment
  module Clojure
    extend Base

    LANGUAGE = "clojure"
    VERSION = "1.10.2.774"

    SCRIPT_PATH = "/script.clj"

    DOCKERFILE_DIR = File.join(__dir__, LANGUAGE)
    DOCKERFILE_ARGS = {
      LANGUAGE: LANGUAGE,
      VERSION: VERSION,
    }
  end
end
