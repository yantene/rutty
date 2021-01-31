ARG VERSION

FROM mcr.microsoft.com/dotnet/sdk:${VERSION}-alpine
ENV RUNNER_HOME /home/runner
ENV SCRIPT_NAMR script.csx
ENV SCRIPT_PATH ${RUNNER_HOME}/${SCRIPT_NAMR}
ENV ENTRY_PATH ${RUNNER_HOME}/entry.sh

RUN adduser -h ${RUNNER_HOME} -D runner nobody

RUN dotnet tool install dotnet-script --tool-path /usr/bin 
COPY ./entry.sh ${ENTRY_PATH}
RUN chown runner ${ENTRY_PATH}
RUN chmod 500 ${ENTRY_PATH}
RUN apk --no-cache add sudo

USER runner
RUN echo 'System.Console.WriteLine("cache")'  >> ${SCRIPT_PATH}
RUN chmod 500 ${SCRIPT_PATH}
RUN dotnet script ${SCRIPT_PATH}

USER root

ENTRYPOINT ${ENTRY_PATH}
