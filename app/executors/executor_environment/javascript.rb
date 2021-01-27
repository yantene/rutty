module ExecutorEnvironment
  module Javascript
    LANGUAGE = "javascript"
    IMPLEMENTATION = "node"
    VERSION = "15.6.0"

    SCRIPT_PATH = "/script.js"

    DOCKERFILE = <<~DOCKERFILE
      FROM #{IMPLEMENTATION}:#{VERSION}-alpine3.10

      RUN apk --update add sudo && rm -rf /var/cache/apk/*

      RUN { \
          echo "#!/bin/sh"; \
          \
          echo "chown nobody:nobody #{SCRIPT_PATH}"; \
          echo "chmod 500 #{SCRIPT_PATH}"; \
          \
          echo "/usr/bin/sudo -u nobody \\\\"; \
          echo "/usr/local/bin/node #{SCRIPT_PATH} \\\\"; \
        } > /entry.sh && \
        chmod 500 /entry.sh

      ENTRYPOINT "/entry.sh"
    DOCKERFILE

    IMAGE = Docker::Image.build(DOCKERFILE)
  end
end
