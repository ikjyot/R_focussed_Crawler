if("pacman" %in% rownames(installed.packages()) == FALSE) {
  install.packages("pacman")
  library("pacman")
  }else{
  library("pacman")
  }

p_load("Rcrawler")

#GET THE TOTAL NUMBER OF VOLUMES
Data = ContentScraper("https://academic.oup.com/dnaresearch",'//child::span[@class="volume trailing-comma"]',"article_link", encod = "text/html")

total_vols = regexpr("[0-9]+",Data)
recent_vol = as.numeric(regmatches(unlist(Data), total_vols))

#CREATE DIRECTORY IN WHICH ARTICLES WILL BE DOWNLOADED
dir.create("../articles")

#LOOP OVER ALL VOLUMES AND ALL ISSUES IN EACH VOLUME
for(i in 1:recent_vol){
  for(j in 1:6){
    #SINCE THE 6TH ISSUE OF VOL24 IS NOT OUT YET, WHEN OUT, IF STATEMENT CAN BE REMOVED
    if(i==24 & j==6){break}
    
    #EXTRACT ALL THE LINKS ON EACH VOLS EACH ISSUE PAGE
    pageinfo <- LinkExtractor(paste0("https://academic.oup.com/dnaresearch/issue/",i,"/",j))
    
    #KEEP ONLY THE LINKS FOR THE ARTICLES IN THAT ISSUE
    al = grep("/article/[0-9]+", pageinfo[[2]], value = TRUE)
    
    #LOOP OVER ALL THE ARTICLE LINKS IN A SINGLE ISSUE AND DOWNLOAD FILES AS DOI.html
    for(p in 1:length(al)){
      names = gregexpr("[0-9]{6,7}", al[p])
      doi = unlist(regmatches(al[p], names))
      download.file(al[p],paste0("../articles/",doi,".html"))
    }
  }
}