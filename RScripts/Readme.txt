README

****crawler.r****
This R script finds all the links of the articles in all the issues of all the volumes of DNA Research Journal. It thenextracts the DOI of each article from its link and downloads the file with the name DOI.html in the "articles" directory.

Packages used: RCrawler, pacman

====================================================================================

****parser.r****

This R Script iterates over each file in the "articles" folder (created during the crawling phase) and collects the 10 fileds from each article using XPath expressions. It then appends the the value of these 10 fields during each iteration into a data frame which is then written to a tab delimitted plain "DNA_Research.txt" file.

Packages used: XML, RCurl, pacman

====================================================================================