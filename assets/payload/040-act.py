from bs4 import BeautifulSoup
import urllib2
import sys

LegislationType=sys.argv[1]
LegislationYear=sys.argv[2]
LegislationVolume=sys.argv[3]

CurrentLegislationSection=int(sys.argv[4])

LegislationSection=["introduction","body","schedules"]
LegislationSectionIdentifierType=["class","id","id"]
LegislationSectionIdentifierValue=["LegClearFix LegPrelims","viewLegContents","viewLegContents"]

url="http://www.legislation.gov.uk/"+LegislationType+"/"+LegislationYear+"/"+LegislationVolume+"/"+LegislationSection[CurrentLegislationSection]+"?view=plain"

try:
  page=urllib2.urlopen(url)
  soup = BeautifulSoup(page.read())
  content=soup.findAll('div',{LegislationSectionIdentifierType[CurrentLegislationSection]:LegislationSectionIdentifierValue[CurrentLegislationSection]})
  print content
except urllib2.HTTPError, err:
   if err.code == 404:
    print "404 error"
   else:
    raise


