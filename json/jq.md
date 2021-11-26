# JQ tips

* Tips to parse values from json file
* Convert the json content to a new format

```
export file='pages.json'

# Get content for all pages

#Get the page array
cat $file | jq '.query.pages|.[]'  

#further get the next level content within the array
cat $file | jq '.query.pages|.[]|.[]' 

cat $file | jq '.query.pages|.[]|.[]|.title' #get title

# convert the title into a new array (list)
cat $file | jq '[.query.pages|.[]|.[]|.title]' 

# Get TOC extract
cat $file | jq '.query.pages|.[]|.[]|select(.title=="TOC")|.extract' 

# Get real pages excluding TOC and Pre-face, convert to a new array
cat $file | jq '.query.pages|.[]|.[]|select(.title!="TOC" and .title !="Pre-face")|.extract'
cat $file | jq '[.query.pages|.[]|.[]|select(.title!="TOC" and .title !="Pre-face")|{title:.title, description:.extract}]'
cat $file | jq '[.query.pages|.[]|.[]|select(.pageid!=0)|{title:.title, description:.extract}]'
```
# Get all shortnames mappwing with resource kind for k8s, generate a new simple map
cat k8s-resources.json | jq '.resources[]| select(.shortNames[0]!=null)|{kind:.kind, short:.shortNames[0]}'
cat k8s-resources.json | jq '.resources[]| select(.shortNames[0]!=null)|.kind, .shortNames[0]'

# get all kind list
python3 -m json.tool k8s-resources.json | grep kind


# List only two level keys, dash "-" is not allowed in keys, so use _ instead

cat gce-all.json | jq '.| map_values(keys)' 

cat gce-all.json | jq '.gcapella_cp| map_values(keys)' 