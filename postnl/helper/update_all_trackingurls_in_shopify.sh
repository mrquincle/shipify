#!/bin/bash
source config.sh

ifile=$shipify_tracking_urls

lines=$(wc -l < $ifile)

for line_index in `seq 1 $lines`; do
  source helper/update_trackingurl_in_shopify.sh $line_index
done


