module ExecutorEnvironment
  module Cobol
    LANGUAGE = "cobol"
    VERSION = "3.1.2"

    SCRIPT_PATH = "/script.cob"

    DOCKERFILE = <<~DOCKERFILE
      FROM alpine:3.13.0

      ENV RUN_PKGS "gmp-dev db-dev build-base"
      ENV DEV_PKGS "curl"
      ENV GNUCOBOL_URL "https://sourceforge.net/projects/gnucobol/files/gnucobol/3.1/gnucobol-#{VERSION}.tar.xz/download"

      RUN apk --update --no-cache add ${RUN_PKGS}

      RUN \
        apk add --virtual build-dependencies --no-cache ${DEV_PKGS} && \
        curl -L ${GNUCOBOL_URL} | tar Jxf - && \
        cd /gnucobol-#{VERSION} && \
        ./configure && \
        make && \
        make install && \
        rm -rf /gnucobol-#{VERSION} && \
        apk del build-dependencies

      RUN apk --no-cache add sudo

      RUN { \
          echo "#!/bin/sh"; \
          \
          echo "chown nobody:nobody #{SCRIPT_PATH}"; \
          echo "chmod 500 #{SCRIPT_PATH}"; \
          \
          echo "/usr/bin/sudo -u nobody \\\\"; \
          echo "/usr/local/bin/cobc -Fx #{SCRIPT_PATH} -o /tmp/script && "; \
          \
          echo "/usr/bin/sudo -u nobody /tmp/script"; \
        } > /entry.sh && \
        chmod 500 /entry.sh

      ENTRYPOINT "/entry.sh"
    DOCKERFILE

    IMAGE = Docker::Image.build(DOCKERFILE)
  end
end
