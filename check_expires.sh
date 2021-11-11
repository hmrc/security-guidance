#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

url="https://tax.service.gov.uk/.well-known/security.txt"
echo "INFO: requesting security.txt file from ${url}"

datetime=$(curl -q --fail -L ${url} | sed -n -e 's/^.*Expires: //p')

warn_if_less_than='1 month'

expires=$(date --date "${datetime}" +'%s')    
warning_window=$(date --date "$warn_if_less_than" +'%s')

echo "INFO: expires=${datetime} (${expires}),  warning_window=${warn_if_less_than} (${warning_window})" >&2

if [ "${expires}" -lt "${warning_window}" ]; then
       echo "ERORR: security.txt will expire in less than ${warn_if_less_than}"
       exit 3
else
       echo "INFO: security.txt will be valid for at least ${warn_if_less_than}"
       exit 0
fi
