#!/bin/bash

echo "> building .venv"
python3.11 -m venv .venv
.venv/bin/python3.11 -m pip install -r requirements.txt 
