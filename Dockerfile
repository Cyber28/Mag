FROM elixir:latest

WORKDIR /opt/mag

COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

EXPOSE 8000
CMD mix run