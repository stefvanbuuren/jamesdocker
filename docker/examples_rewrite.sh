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
key=x039782e37a6024
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

# POST: opencpu session (internal)
curl localhost://charts/draw -d "chartcode='NMBA'&selector='chartcode'"

# POST: name of empty chart (chartcode) (external)
curl localhost://charts/draw/print -d "chartcode='NMBB'&selector='chartcode'"

# POST: ask for empty chart with code NMBA (external)
# FAILS
# curl -X POST localhost://charts/NMBA

# GET: R documentation draw_chart (external)
curl localhost://charts/draw/man


# --> How do we add data to a chart?

# POST: upload local child data and plot on NMBB (chartcode) (external)
curl localhost://charts/draw -d "txt=$dat&chartcode='NMBB'&selector='chartcode'"

# POST: read child data from storage and plot on NMBB (chartcode) (faster for multiple graphs) (external)
curl localhost://charts/draw -d "loc='http://localhost/ocpu/tmp/$key/'&chartcode='NMBB'&selector='chartcode'"

# POST: read child data from storage and plot on NMBB
# the nicer way, but it does not work
# curl localhost://$key/charts/NMBB

# POST: read child data from storage and plot on NMBB
# slightly simplified, but also does not work
# curl localhost://$key/charts/draw -d "chartcode='NMBB'&selector='chartcode'"


# ---> How do we download the chart?

# download chart, the short path
cht=x0cc40eb12bfda1
curl -o mychart1.svg "localhost/$cht/svg?width=8.27&height=11.69" -H 'Cache-Control: max-age=0'

# download chart, the long path (oldstyle)
curl -o mychart2.svg "localhost/ocpu/tmp/$cht/graphics/1/svglite?width=8.27&height=11.69" -H 'Cache-Control: max-age=0'

