#!/bin/sh
set -eu

MODEL_FILE="${MODEL_FILE:?MODEL_FILE is required}"

set -- /app/llama-server \
  -m "/models/${MODEL_FILE}" \
  -c "${CTX:-0}" \
  -ub "${UBATCH:-512}" \
  -b "${BATCH:-512}" \
  --host 0.0.0.0 \
  --port 8080 \
  -ngl "${GPU_LAYERS:--1}"

if [ "${PROMPT_FORMAT:-jinja}" = "jinja" ]; then
  set -- "$@" --jinja
else
  set -- "$@" --chat-template "${CHAT_TPL:-chatml}"
fi

if [ -n "${RPC:-}" ]; then
  set -- "$@" --rpc "${RPC}"
fi

if [ "${METRICS:-0}" = "1" ]; then
  set -- "$@" --metrics
fi

if [ -n "${ALIAS:-}" ]; then
  set -- "$@" --alias "${ALIAS}"
fi

if [ -n "${SERVER_EXTRA_ARGS:-}" ]; then
  # Intentionally allow shell-style word splitting for advanced llama-server flags.
  # shellcheck disable=SC2086
  set -- "$@" ${SERVER_EXTRA_ARGS}
fi

exec "$@"
