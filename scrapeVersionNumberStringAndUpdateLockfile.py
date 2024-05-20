import json
import os
import re
import requests
import xml.etree.ElementTree as ET
# os.getcwd()

with open("renv.lock", "r") as f:
	x = json.load(f)

p = [item for item in x["Packages"].keys()]

for thisPackageName in p:
	if not thisPackageName in ['ContDataQC', 'ContDataSumViz', 'IHA', 'StreamThermal']: 
		print("Working on " + thisPackageName + " ... ")
        r = requests.get("https://cran.r-project.org/web/packages/" + thisPackageName + "/index.html") 
		theTextRaw = r.text
		theText = re.sub("&.*?;", " ", theTextRaw) # re.sub("&.*?;", " ", "a&nbsp;b&gt;c") # https://stackoverflow.com/questions/14744945/parse-xml-with-xhtml-entities 
		tree = ET.fromstring(theText)
        versionNumberStringScrapedFromTheDocumentation = tree.findall("./body/div/table/")[0].findall("./")[1].text 
        x["Packages"][thisPackageName]["Version"] = versionNumberStringScrapedFromTheDocumentation 
        print("     ... done.")

with open("renv.lock", "w") as F:
    json.dump(x, F)

input()
