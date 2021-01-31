module ExecutorEnvironment
  module Csharp
    extend Base

    LANGUAGE = "csharp"
    VERSION = "5.0"

    SCRIPT_PATH = "/home/runner/script.csx"

    DOCKERFILE_DIR = File.join(__dir__, LANGUAGE)
    DOCKERFILE_ARGS = {
      VERSION: VERSION,
    }
  end
end
