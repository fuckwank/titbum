from bs4 import BeautifulSoup
import urllib2
import sys

LegislationType=sys.argv[1]
LegislationYear=sys.argv[2]
LegislationVolume=sys.argv[3]

LegislationSection=["introduction","body","schedules"]
LegislationSectionIdentifierType=["class","id","id"]
LegislationSectionIdentifierValue=["LegClearFix LegPrelims","viewLegContents","viewLegContents"]

url="http://www.legislation.gov.uk/"+LegislationType+"/"+LegislationYear+"/"+LegislationVolume+"/contents"

try:
   page=urllib2.urlopen(url)
   soup = BeautifulSoup(page.read())
   content=soup.title
   print content.string
except urllib2.HTTPError, err:
   if err.code == 404:
    print "404 error"
   else:
    raise

