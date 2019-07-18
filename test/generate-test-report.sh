#!/usr/bin/env bash

set -euxo pipefail

cd "$(dirname "$0")/.."

docker build . -t psalm-html-output:latest

cat test/psalm-report.xml | docker run --rm -i psalm-html-output:latest > test/psalm-report-generated.html
