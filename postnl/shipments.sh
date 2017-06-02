#!/bin/bash

source config.sh

echo "Get delivery information from postnl."
echo "Go to https://mijn.postnl.nl/apex/tt_sent_shipments (copied to clipboard)"

postnl_date_to=$(date '+%d-%m-%Y')
postnl_date_from=$(date '+01-%m-%Y')
 
postnl_tracking_link="https://mijn.postnl.nl/apex/tt_sent_shipments?search=true&filterCustomerNumber=$postnl_accountnr&filterDateFrom=$postnl_date_from&filterDateTo=$postnl_date_to"

echo -n "Open link in the browser [y/N]? " 
read answer

if [ "$answer" == "y" ]; then
  xdg-open "$postnl_tracking_link"
fi

postnl_file=$downloads/export.csv

if [ -e "$postnl_file" ]; then
  echo "Use new $shipify_db_shipments file"
  mv $postnl_file $shipify_db_shipments
else
  echo "Use existing $shipify_db_shipments file"
fi

echo "Transforming csv output from postnl to tracking URLs"
source helper/postnl2trackingurls.sh

echo "Copy to shopify one by one"
source helper/update_all_trackingurls_in_shopify.sh


