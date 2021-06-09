FROM elixir:1.12.1
ARG tg_token 
WORKDIR /app
COPY . .
RUN export MIX_ENV=prod && \
    export TG_TOKEN=${tg_token} && \
    mix local.rebar --force && \
    rm -Rf _build && \
    rm -rf deps && \
    mix local.hex --force && \
    mix deps.get && \
    mix release

CMD ["_build/prod/rel/app/bin/app", "start"]