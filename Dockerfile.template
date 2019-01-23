FROM balenalib/%%RESIN_MACHINE_NAME%%-debian

RUN apt-get update && apt-get install -y curl wget build-essential libelf-dev awscli bc flex libssl-dev python
COPY . /usr/src/app
WORKDIR /usr/src/app

ENV VERSION '2.29.0+rev1.prod'
RUN ./build.sh %%RESIN_MACHINE_NAME%% $VERSION example_module

CMD ./run.sh
