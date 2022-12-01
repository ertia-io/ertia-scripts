#!/bin/bash

set -euo pipefail

USER="loki"
LOKI_URL="${1:?}"
PASSWORD="${2:?}"
LEVEL="${3:?}"
SERVICE="${4:?}"
BUILD="${5:?}"
MSG="${6:?}"

TIMESTAMP=$(date +%s000000000)
DATA=$(jq -n \
  --arg timestamp "${TIMESTAMP}" \
'{"streams": [{"stream": {"app":"df-loki-deployment"}, "values": [[$timestamp,"level='"${LEVEL}"' service='"${SERVICE}"' build='"${BUILD}"' msg=\"'"${MSG}"'\""]] }]}')

if (($# > 6)); then
  RUNTIME="${7:?}"
  DATA=$(jq -n \
    --arg timestamp "${TIMESTAMP}" \
'{"streams": [{"stream": {"app":"df-loki-deployment"}, "values": [[$timestamp,"level='"${LEVEL}"' service='"${SERVICE}"' build='"${BUILD}"' runtime='"${RUNTIME}"' msg=\"'"${MSG}"'\""]] }]}')

fi

curl -u "${USER}:${PASSWORD}" -XPOST -H "Content-Type: application/json" "${LOKI_URL}" -d "${DATA}" 
 

