from bs4 import BeautifulSoup
import urllib2
url="http://www.legislation.gov.uk/browse"
baseurl="http://www.legislation.gov.uk"
page=urllib2.urlopen(url)
soup = BeautifulSoup(page.read())

content=soup.find(id="content")
Legislation= content.find_all('a')

for LegislationType in Legislation:
   print baseurl+LegislationType['href']+","+str(LegislationType.string)+","+LegislationType['href']
