# --> How can I upload data and get a key?

# GET: download example data
curl https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json -O

# POST: upload dataset from local file
curl -X POST -F 'txt=@client3.json' localhost/key

# POST: upload dataset as a JSON string (assumes jq utility installed)
dat=$(jq '.' client3.json | jq -sR '.')
curl localhost/key -d "txt=$dat"

# store key to my data on the server
key=x0df5a91ec5d8b4
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
curl -X POST localhost://charts/NMBA

# GET: R documentation draw_chart (external)
curl localhost://charts/draw/man


# --> How do we add data to a chart?
curl localhost://$key/charts/NMBA/svg

