module ExecutorEnvironment
  module Bash
    LANGUAGE = "bash"
    VERSION = "5.1.0"

    SCRIPT_PATH = "/script.sh"

    DOCKERFILE = <<~DOCKERFILE
      FROM alpine:3.13.0
      
      RUN apk --update add #{LANGUAGE}=#{VERSION}-r0 sudo && rm -rf /var/cache/apk/*
      
      RUN { \
          echo "#!/bin/sh"; \
          \
          echo "chown nobody:nobody #{SCRIPT_PATH}"; \
          echo "chmod 500 #{SCRIPT_PATH}"; \
          \
          echo "/usr/bin/sudo -u nobody \\\\"; \
          echo "/bin/bash #{SCRIPT_PATH} \\\\"; \
        } > /entry.sh && \
        chmod 500 /entry.sh
      
      ENTRYPOINT "/entry.sh"
    DOCKERFILE

    IMAGE = Docker::Image.build(DOCKERFILE)
  end
end
