# --> How can I upload data and get a key?

# GET: download example data
curl https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json -O

# POST: upload local file to groeidiagrammen.nl (oldstyle)
curl -X POST -F 'txt=@client3.json' https://groeidiagrammen.nl/ocpu/library/james/R/fetch_loc

# POST: upload local file client3.json to localhost
curl -X POST -F 'txt=@client3.json' localhost/key

# POST: upload dataset as a JSON string (assumes jq utility installed)
dat=$(jq '.' client3.json | jq -sR '.')
curl localhost/key -d "txt=$dat"

# store key to my data on the server
key=x0cd14ee778d0fb
echo $key



# --> How can I inspect my uploaded data?

# inspect session of uploaded data
curl localhost/$key

# view uploaded data
curl localhost/$key/print

# download uploaded and validated data as JSON
curl localhost/$key/json > fromjames.json

# inspect validation messages
curl localhost/$key/messages

# we can ask: print, json, svg, console, stdout, warnings, messages, info, source, R, files



# --> Which charts can we make?

# POST: opencpu session (internal)
curl -X POST localhost://charts/list

# POST: JSON list of all chart codes (external)
curl -X POST localhost://charts/list/json

# POST: table of all chart codes (external)
curl -X POST localhost://charts/list/print

# GET: R documentation list_charts() (external)
curl localhost://charts/list/man



# --> How do we select a specific chart?

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

# GET: R documentation draw_chart (external)
curl localhost://charts/draw/man



# --> How do we add data to a chart?

# POST: upload local child data and plot on NMBA (chartcode) (external)
curl localhost://charts/draw -d "txt=$dat&chartcode='NMBA'&selector='chartcode'"

# POST: read child data from storage and plot on NMBA (chartcode) (faster for multiple graphs) (external)
curl localhost://charts/draw -d "loc='http://localhost/ocpu/tmp/$key/'&chartcode='NMBA'&selector='chartcode'"

# POST: read child data from storage and plot on NMBA - neat URL
# the nicer way, but it does not work
# probably same cause because OpenCPU still has to create resource
# curl -X POST localhost://$key/charts/NMBA

# POST: read child data rom storage and plot on NMBA
# slightly simplified, but also does not work
# curl -X POST localhost://$key/charts/draw -d "chartcode='NMBA'&selector='chartcode'"



# ---> How do I download the chart?

# download chart, the short path
cht=x06c34f2abc8170
curl -o mychart1.svg "localhost/$cht/svg?width=8.27&height=11.69" -H 'Cache-Control: max-age=0'

# download chart, the long path (oldstyle)
curl -o mychart2.svg "localhost/ocpu/tmp/$cht/graphics/1/svglite?width=8.27&height=11.69" -H 'Cache-Control: max-age=0'



## ---> How do I obtain a personalised site?


