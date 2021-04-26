# Copyright (C) 2021 Jingyi Xie (hsfzxjy) <hsfzxjy@gmail.com>
# All rights reserved.

# Usage: gdl <URL> <OUTPUT>
# This function downloads Google Drive contents from <URL> to <OUTPUT>.
# Supported URL formats are:
#   1. https://drive.google.com/file/d/<file_id>/view?usp=sharing
#   2. https://drive.google.com/u/0/uc?id=<file_id>&export=download
function gdl() {
    URL=$1
    OUTPUT=$2
    RE_IS_VIEW_URL='.*d/([^/]+)/view'
    RE_IS_UC_URL='^https://drive.google.com/u/0/uc'

    # If URL is in format (1), turn it into format (2)
    if [[ "${URL}" =~ ${RE_IS_VIEW_URL} ]]; then
        FILE_ID="${BASH_REMATCH[1]}"
        URL="https://drive.google.com/u/0/uc?id=${FILE_ID}&export=download"
    fi

    # Check if URL is in format (2)
    if ! [[ "${URL}" =~ $RE_IS_UC_URL ]]; then
        return 1
    fi

    # Create a temporary file to hold confirm code
    TMP_FILE=$(mktemp)
    CODE=$(wget --save-cookies ${TMP_FILE} --keep-session-cookies --no-check-certificate ${URL} -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')
    echo Confirm code: ${CODE}
    URL+="&confirm=${CODE}"
    wget --load-cookies ${TMP_FILE} ${URL} -O ${OUTPUT}
    rm ${TMP_FILE}
}
