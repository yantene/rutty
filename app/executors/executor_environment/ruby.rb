module ExecutorEnvironment
  module Ruby
    LANGUAGE = "ruby"
    VERSION = "3.0.0"

    SCRIPT_PATH = "/script.rb"

    DOCKERFILE = <<~DOCKERFILE
      FROM #{LANGUAGE}:#{VERSION}-alpine
      
      RUN apk --update add sudo && rm -rf /var/cache/apk/*
      
      RUN { \
          echo "#!/bin/sh"; \
          \
          echo "chown nobody:nobody #{SCRIPT_PATH}"; \
          echo "chmod 500 #{SCRIPT_PATH}"; \
          \
          echo "/usr/bin/sudo -u nobody \\\\"; \
          echo "/usr/local/bin/ruby #{SCRIPT_PATH} \\\\"; \
        } > /entry.sh && \
        chmod 500 /entry.sh
      
      ENTRYPOINT "/entry.sh"
    DOCKERFILE

    IMAGE = Docker::Image.build(DOCKERFILE)
  end
end
