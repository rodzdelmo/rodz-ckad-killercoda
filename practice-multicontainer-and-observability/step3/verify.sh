#!/bin/bash
set -euo pipefail

answer_file="/root/metrics-relay.txt"

if [[ ! -f "$answer_file" ]]; then
  echo "$answer_file does not exist."
  exit 1
fi

command_line="$(cat "$answer_file")"

if [[ "$command_line" != *"logs"* || "$command_line" != *"metrics-relay"* ]]; then
  echo "$answer_file must contain a kubectl logs command targeting metrics-relay."
  exit 1
fi

if [[ "$command_line" != *"exporter"* ]]; then
  echo "$answer_file must target the exporter container specifically."
  exit 1
fi

if [[ "$command_line" == *" relay"* && "$command_line" != *"exporter"* ]]; then
  echo "$answer_file must target exporter, not relay."
  exit 1
fi

if ! bash -c "$command_line" >/dev/null 2>&1; then
  echo "The command in $answer_file did not run successfully."
  exit 1
fi

echo "Success: $answer_file contains a working logs command for the exporter container."
exit 0
