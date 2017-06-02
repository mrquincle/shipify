#!/bin/bash

line_index=${1:? "Usage: line_index" }

source config.sh

ifile=$shipify_tracking_urls

order=$(cat "$ifile"| tail -${line_index} | head -1)

index=$(echo $order | cut -f1 -d'|')

shopify_url=https://dobots.myshopify.com/admin/orders?query=$index
echo "Go to url: " 
echo "    $shopify_url (press enter to get it in your clipboard)"
read nothing
echo $shopify_url | xclip -se c

url=$(echo $order | cut -f4 -d'|')
echo "Copy tracking url" 
echo "    $url (press enter to get it in your clipboard)"
read nothing
echo $url | xclip -se c

code=$(echo $url | cut -f6 -d'/')
echo "Copy tracking code"
echo "    $code (press enter to get it in your clipboard)"
read nothing
echo $code | xclip -se c
