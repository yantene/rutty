module ExecutorEnvironment
  module Javascript
    extend Base

    LANGUAGE = "javascript"
    IMPLEMENTATION = "node"
    VERSION = "15.6.0"

    SCRIPT_PATH = "/script.js"

    DOCKERFILE_DIR = File.join(__dir__, LANGUAGE)
    DOCKERFILE_ARGS = {
      IMPLEMENTATION: IMPLEMENTATION,
      VERSION: VERSION,
    }
  end
end
