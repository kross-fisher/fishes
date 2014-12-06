#! /bin/bash
# query -- view or search the web
# usage:
#   query open <http-url>       open the specified web-page
#   query search <keywords>     search with the default engine

function search() {
    adb -d shell am start -a android.intent.action.WEB_SEARCH \
        --es query "$@"
}

function open() {
    adb -d shell am start -a android.intent.action.VIEW -d "$@"
}

action=$1; shift

if [ "$action" = "open" ]; then
    open "$@"
elif [ "$action" = "search" ]; then
    search "$@"
else
    echo "Usage:"
    echo "       . query.sh search [keywords]"
    echo "       . query.sh open <http-url>"
fi
