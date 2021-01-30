module ExecutorEnvironment
  module Cobol
    extend Base

    LANGUAGE = "cobol"
    IMPLEMENTATION = "gnucobol"
    VERSION = "3.1.2"

    SCRIPT_PATH = "/script.cob"

    DOCKERFILE_DIR = File.join(__dir__, LANGUAGE)
    DOCKERFILE_ARGS = {
      IMPLEMENTATION: IMPLEMENTATION,
      VERSION: VERSION,
      MINOR_VERSION: VERSION.split(".").take(2).join("."),
    }
  end
end
