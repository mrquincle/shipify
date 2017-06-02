#!/bin/bash

source config.sh

ifile=$shipify_db_shipments
ofile=$shipify_tracking_urls

tmpfile1=$(mktemp)
tmpfile2=$(mktemp)
trap "{ rm -f $tmpfile1 $tmpfile2; }" EXIT

# We use csvtool to separate out the order number, the tracking code, and the addressee (which is of variable length)
csvtool -t ';' -u '|' col 2,5,3 $ifile | cut -f1- -d',' | tail -n+2 > $tmpfile1

while FS='' read -r line; do
  # Get first item before |
  order=$(echo $line | cut -f1 -d'|')
  # Get second item before |
  trackingcode=$(echo $line | cut -f2 -d'|')
  # Get very last item after ,
  country=$(echo $line | rev | cut -f1 -d',' | rev | tr -d ' ')
  # Get third-last item after ,
  postalcode=$(echo $line | rev | cut -f3 -d',' | rev | tr -d ' ')
  # Get first item before ,
  name=$(echo $line | cut -f1 -d',' | rev | cut -f1 -d '|' | rev)
  
  # Prefix for all URLs
  url='https://jouw.postnl.nl/#!/track-en-trace'
  
  # Depends on format?
  case $country in
    'Nederland'|'NL')
      countrycode="NL"
      ;;
    'Denemarken')
      countrycode="DK"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'Zweden')
      countrycode="SE"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'Frankrijk')
      countrycode="FR"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'Finland')
      countrycode="FI"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'Duitsland')
      countrycode="DE"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'België')
      countrycode="BE"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'Zwitserland')
      countrycode="CH"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'Oostenrijk')
      countrycode="AT"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    'Griekenland')
      countrycode="GR"
      url='https://www.internationalparceltracking.com/Main.aspx#/track'
      ;;
    *)
      countrycode="UNKNOWN_COUNTRYCODE"
  esac
  echo "$order|$trackingcode|$name|$url/${trackingcode}/$countrycode/$postalcode" >> "$tmpfile2"
done < "$tmpfile1"

echo "Result can be found in $ofile"
cat $tmpfile2 > $ofile
