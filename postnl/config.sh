#!/bin/bash

export today=$(date '+%Y%m%d')

export shipify_db_path=$HOME/.shipify

export shipify_db_shipments=$shipify_db_path/postnl_export.csv

export shipify_tracking_urls=$shipify_db_path/postnl_tracking_urls.txt

export downloads=$HOME/setup

export config_file=$shipify_db_path/shipify.cfg

mkdir -p $shipify_db_path
touch $config_file

source $config_file

