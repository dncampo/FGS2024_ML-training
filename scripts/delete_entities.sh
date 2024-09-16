#!/bin/bash

 mongo "orion-health" --eval "db.dropDatabase()" --port 27018
