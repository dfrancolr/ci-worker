#!/bin/bash
TAG="dfrancolr/ci-worker:1.0.7"
docker build -t ${TAG} "${@}" .