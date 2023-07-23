#!/bin/bash
# shellcheck disable=SC1083 # literal /

######################################################################
# Script provided AS IS and created as proof of concept for blogpost #
# https://clementine.la/scripts/scheduled-updates-menu-bar-sumb/     #
######################################################################

#####################################
# AUTHENTICATION TOKEN              #
# Code by Rich Trouton              #
# https://derflounder.wordpress.com #
#####################################

# Explicitly set initial value for the api_token variable to null:
api_token=""

# Jamf Pro URL (without trailing slash)
jamfpro_url="https://YOUR_COMPANY.jamfcloud.com"

# Jamf Pro User
jamfpro_user="jamf-api"

# Jamf Pro Password
jamfpro_password="YOUR_PASSWORD"

echo

# Remove the trailing slash from the Jamf Pro URL if needed.
jamfpro_url=${jamfpro_url%%/}

GetJamfProAPIToken() {

# This function uses Basic Authentication to get a new bearer token for API authentication.
# Use user account's username and password credentials with Basic Authorization to request a bearer token.

if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
   api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}/api/v1/auth/token" | python -c 'import sys, json; print json.load(sys.stdin)["token"]')
else
   api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}/api/v1/auth/token" | plutil -extract token raw -)
fi

}

APITokenValidCheck() {

# Verify that API authentication is using a valid token by running an API command
# which displays the authorization details associated with the current API user. 
# The API call will only return the HTTP status code.

api_authentication_check=$(/usr/bin/curl --write-out %{http_code} --silent --output /dev/null "${jamfpro_url}/api/v1/auth" --request GET --header "Authorization: Bearer ${api_token}")

}

GetJamfProAPIToken
APITokenValidCheck
echo "API Auth Check : $api_authentication_check"
#echo "$api_token"


##############
# SUMB LOGIC #
##############

# Get UUID
computerUDID=$(system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }')

# Get JSSID from Jamf
JSSID=$(defaults read "/Users/Shared/sumb/jssid.plist" JSSID)

if [ -z "$JSSID" ]; then
   JSSID=$(curl --header "Authorization: Bearer ${api_token}" --header "Accept: application/xml" --request GET --url "${jamfpro_url}/JSSResource/computers/udid/${computerUDID}/subset/General" 2> /dev/null | xpath -e /computer/general/id 2>&1 | awk -F '<id>|</id>' '{print $2}' | xargs)
   echo "JSSID : $JSSID"
   defaults write "/Users/Shared/sumb/jssid.plist" JSSID "$JSSID"
   chmod 444 "/Users/Shared/sumb/jssid.plist"
else
   echo "JSSID already fetched : $JSSID"
fi

# Get scheduled updates status
curl -X GET \
     --url "$jamfpro_url/api/v1/managed-software-updates/update-statuses/computers/$JSSID" \
     -H  "accept: application/json" \
     -H  "Authorization: Bearer $api_token" \
     -o "/Users/Shared/sumb/app.sumb.managedsoftwareupdate.json"

# Without JQ, converting JSON to PLIST
if [ -e "/Users/Shared/sumb/app.sumb.managedsoftwareupdate.json" ]; then
    # Replace 'null' with integer numbers otherwise plutil fails
    sed 's/null/999/g' "/Users/Shared/sumb/app.sumb.managedsoftwareupdate.json" > "/Users/Shared/sumb/temp_app.sumb.managedsoftwareupdate.json"
    mv "/Users/Shared/sumb/temp_app.sumb.managedsoftwareupdate.json" "/Users/Shared/sumb/app.sumb.managedsoftwareupdate.json"
    plutil -convert xml1 "/Users/Shared/sumb/app.sumb.managedsoftwareupdate.json" -o "/Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist"
    rm -f "/Users/Shared/sumb/app.sumb.managedsoftwareupdate.json"
else
    echo "Fetching JSON has failed. Exiting."
    exit 1
fi

# Refresh SwiftBar
open -g "swiftbar://refreshplugin?name=sumb"
