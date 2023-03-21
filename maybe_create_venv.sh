#!/bin/bash

# this script ensures that .venv is in sync with requirements.txt, by tracking a hash in .venv/requirements-hash

set -x
set -e

HERE=$(dirname $(readlink -f $0))
cd $HERE

if [ -d ".venv" ]; then
    echo "> .venv does exist"
    if [ -f ".venv/requirements-hash" ]; then
        echo "> .venv/requirements-hash does exist"
        if [ "$(cat requirements.txt | sha256sum)" == "$(cat .venv/requirements-hash)" ]; then
            echo "> .venv/requirements-hash does match"
            exit 0
        else
            echo "> .venv/requirements-hash does NOT match"
        fi
    else
        echo "> .venv/requirements-hash does NOT exist"
    fi

    echo "> removing stale .venv"
    rm -rf .venv
else
    echo "> .venv does NOT exist"
fi

echo "> building .venv"
python3.11 -m venv .venv
.venv/bin/python3.11 -m pip install -r requirements.txt
echo "> building .venv/requirements-hash"
cat requirements.txt | sha256sum | tee .venv/requirements-hash
echo "> setting PYTHONPATH"
site_packages=$HERE/.venv/lib/python3.11/site-packages
echo $HERE > $site_packages/cs-library.pth
