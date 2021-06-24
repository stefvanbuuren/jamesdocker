# --> How can I upload data to server and get a key to it?

# GET: download example data
curl https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json -O

# POST: upload local file to groeidiagrammen.nl (oldstyle, not recommended)
curl -X POST -F 'txt=@client3.json' https://groeidiagrammen.nl/ocpu/library/james/R/fetch_loc

# POST: upload local file client3.json to localhost (new style)
curl -X POST -F 'txt=@client3.json' localhost/upload

# POST: upload dataset as a JSON string (assumes jq utility installed)
txt=$(jq '.' client3.json | jq -sR '.')
curl localhost/upload -d "txt=$txt"

# extract key to upload on the server
key=x0df32370ff41f4
echo $key

# GET: R documentation for upload
curl localhost/upload/man



# --> How can I inspect my session?

# inspect session of uploaded data
curl localhost/$key

# view uploaded data
curl localhost/$key/print

# download uploaded and validated data as JSON
curl localhost/$key/json > uploaded.json

# inspect validation messages, if any
curl localhost/$key/messages

# we can ask: print, json, svg, console, stdout, warnings, messages, info, source, R, files



# --> Which charts can I make?

# POST: JSON list of all chart codes
curl -X POST localhost/charts/list/json

# POST: return text table of all chart codes
curl -X POST localhost/charts/list/print

# GET: R documentation list_charts()
curl localhost://charts/list/man



# --> How do I select a specific chart?

# POST: draw empty chart NMBA
curl localhost://charts/draw -d "chartcode='NMBA'&selector='chartcode'"

# POST: check whether chartcode of output is correct: gtree[NMBA]
curl localhost://charts/draw/print -d "chartcode='NMBA'&selector='chartcode'"

# POST: ask for empty chart with code NMBA with neat URL
# FAILS
# Using: RewriteRule ^/charts/([A-Za-z0-9]+)((\/$|$))  /ocpu/library/james/R/draw_chart?chartcode=$1&selector=chartcode [R,PT,QSA]
# It might not be possible without additional javascript
# https://stackoverflow.com/questions/8581054/how-do-i-rewrite-a-post-request-from-a-form-to-a-user-friendly-url-with-htaccess
# curl -X POST localhost://charts/NMBA


# --> How do I add data to the chart?

# POST: upload local child data and draw default chart
curl localhost/charts/draw -d "txt=$txt"

# POST: read child data from storage and draw default chart
# FAILS
# curl -X POST localhost/$key/charts/draw

# POST: upload local child data and plot on NMBA (chartcode)
curl localhost/charts/draw -d "txt=$txt&chartcode='NMBA'&selector='chartcode'"

# POST: read child data from storage and plot on NMBA (chartcode) (faster for multiple graphs)
curl localhost/charts/draw -d "loc='http://localhost/ocpu/tmp/$key/'&chartcode='NMBA'&selector='chartcode'"

# POST: read child data from storage and plot on NMBA - neat URL
# the nicer way, but it does not work
# probably same cause because OpenCPU still has to create resource
# curl -X POST localhost://$key/charts/NMBA

# POST: read child data rom storage and plot on NMBA
# slightly simplified, but also does not work
# curl -X POST localhost://$key/charts/draw -d "chartcode='NMBA'&selector='chartcode'"

# GET: R documentation for /charts/draw
curl localhost/charts/draw/man



# ---> How do I download the chart?

# download chart, the short path
cht=x0d5c6128776291
curl -o mychart1.svg "localhost/$cht/svg?width=8.27&height=11.69" -H 'Cache-Control: max-age=0'

# download chart, the long path (oldstyle)
curl -o mychart2.svg "localhost/ocpu/tmp/$cht/graphics/1/svglite?width=8.27&height=11.69" -H 'Cache-Control: max-age=0'

# GET: documentation for $cht/svg
curl localhost://ocpu/library/svglite/man/svglite/text



## ---> How do I screen the growth of a child for abnormalities?

# POST: upload local child data and screen all outcomes
curl localhost://screeners/growth -d "txt=$txt"

# POST: read child data from storage and screen all growth parameters (faster)
curl localhost://screeners/growth -d "loc='http://localhost/ocpu/tmp/$key/'"

# GET: download results from screeners
scr=x04875911c17e56
curl -o screen.json "localhost/$scr/json"

# GET: R documentation for screeners/growth
curl localhost/screeners/growth/man


## ---> How do I obtain a personalised site?


