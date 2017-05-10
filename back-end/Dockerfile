FROM kelecorix/stack-build-lumper:latest
MAINTAINER sigrlami <sergey.bushnyak@sigrlami.eu>

# Copy everything to docker ecosystem
WORKDIR /app/
COPY ["./docker-entrypoint.sh","./LICENSE","./*.cabal","./stack.yaml", "./"]
COPY ./app  ./app
COPY ./src/ ./src

RUN stack build --no-docker

RUN chmod 775 /app/docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD run
