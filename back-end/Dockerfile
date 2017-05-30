FROM haskell:8

# install database dependencies
RUN ["apt-get", "update"]
RUN ["apt-get", "-y", "install", "libpq-dev"]

# Copy everything to docker ecosystem
WORKDIR /app/
COPY ["./docker-entrypoint.sh","./*.cabal","./stack.yaml", "./"]
COPY ./app  ./app
COPY ./src/ ./src

RUN stack build --no-docker

CMD stack exec dara-exe

EXPOSE 8080

#RUN chmod 775 /app/docker-entrypoint.sh
#
#ENTRYPOINT ["/app/docker-entrypoint.sh"]
#
#CMD run
