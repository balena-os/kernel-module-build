FROM resin/intel-nuc-debian
RUN apt-get update && apt-get install -y curl wget build-essential libelf-dev
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN ./build.sh intel-nuc '2.26.0+rev1.dev' example_module

CMD ./run.sh
