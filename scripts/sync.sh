#!/bin/bash

manifests_dir=$(pwd)

cd_service() {
	echo "syncing service $1"
	cd "../$1"
}

reset_dir() {
	cd "$manifests_dir"
}

cd_service "dead-letter-data"
git pull
make proto/gen
reset_dir

cd_service "dead-letter-business-auth"
git pull
reset_dir
