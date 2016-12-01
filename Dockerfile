FROM resin/ts4900-debian

RUN apt-get update && apt-get install -y curl wget build-essential
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN ./build.sh ts4900 2.0.0-beta.2 example_module

CMD ./run.sh
