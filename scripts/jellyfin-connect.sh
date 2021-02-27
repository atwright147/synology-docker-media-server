#!/bin/bash

/usr/bin/curl -v -d "" -H "X-MediaBrowser-Token: JELLYFIN_TOKEN" http://JELLYFIN_ADDRESS:8096/library/refresh
