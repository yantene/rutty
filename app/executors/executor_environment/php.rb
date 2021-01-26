module ExecutorEnvironment
  module Php
    LANGUAGE = "php"
    VERSION = "8.0.1"

    SCRIPT_PATH = "/script.php"

    DOCKERFILE = <<~DOCKERFILE
      FROM #{LANGUAGE}:#{VERSION}-cli-alpine
      
      RUN apk --update add sudo && rm -rf /var/cache/apk/*

      RUN { \
          echo "display_errors = stderr"; \
      } > /usr/local/etc/php/php.ini
      
      RUN { \
          echo "#!/bin/sh"; \
          \
          echo "chown nobody:nobody #{SCRIPT_PATH}"; \
          echo "chmod 500 #{SCRIPT_PATH}"; \
          \
          echo "/usr/bin/sudo -u nobody \\\\"; \
          echo "/usr/local/bin/php #{SCRIPT_PATH} \\\\"; \
        } > /entry.sh && \
        chmod 500 /entry.sh
      
      ENTRYPOINT "/entry.sh"
    DOCKERFILE

    IMAGE = Docker::Image.build(DOCKERFILE)
  end
end
