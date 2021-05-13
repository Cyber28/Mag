FROM elixir:latest

WORKDIR /opt/mag

COPY . .

RUN mix local.hex --force
RUN mix deps.get

EXPOSE 8000
CMD mix run