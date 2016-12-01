FROM resin/ts4900-debian

RUN apt-get update && apt-get install -y curl wget build-essential
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN ./build.sh ts4900 '.*' example_module

CMD ./run.sh
