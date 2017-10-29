if("pacman" %in% rownames(installed.packages()) == FALSE) {
  install.packages("pacman")
  library("pacman")
}else{
  library("pacman")
}

p_load("XML","RCurl")

baseURL = "https://academic.oup.com"
journal_name = "DNA_Research"

#INITIALISE A DATA FRAME WITH 10 COLUMNS
Comp_data = data.frame(matrix(ncol = 10, nrow = 0))
colnames(Comp_data) = c("DOI","Title","Authors","AuthorAffiliations",
                        "CorrespondingAuthor","CorrespondingAuthorEmail",
                        "PublicationDate","Abstract","Keywords","FullText")

#==============================================================================================#
#HTML PARSER FUNCTION START
htmlParser <- function(i,doc){
  #DOI
  DOI = gsub(".html","",i)
  
  #TITLE
  Title = xpathSApply(doc, "//h1[@class=\"wi-article-title article-title-main\"]", xmlValue)
  Title = unlist(strsplit(Title,"\n"))[1]
  Title = trimws(Title, which = "both")
  if (Title==""){Title = NA}
  
  #AUTHORS
  Authors = xpathSApply(doc, "//a[@class=\"linked-name\"]/text()", xmlValue)
  Authors = paste0(Authors, collapse = ",")
  if (Authors==""){Authors = NA}
  
  #AUTHOR AFFILIATIONS
  AuthorAffiliations = xpathSApply(doc, "//div[@class=\"aff\"]/text()|//div[@class=\"insititution\"]/text()", xmlValue)
  AuthorAffiliations = paste0(AuthorAffiliations, collapse = ",")
  if (AuthorAffiliations==""){AuthorAffiliations = NA}
  
  #CORRESPONDING AUTHOR
  CorrespondingAuthor = xpathSApply(doc, '//div[@class="info-author-correspondence"]/../../../a/text()', xmlValue)
  CorrespondingAuthor = paste0(CorrespondingAuthor, collapse = ",")
  if (CorrespondingAuthor==""){CorrespondingAuthor = NA}
  
  #CORRESPONDING AUTHOR EMAIL
  CorrespondingAuthorEmail = xpathSApply(doc, '(//div[@class="info-author-correspondence"])[1]/a/text()', xmlValue)
  CorrespondingAuthorEmail = paste0(CorrespondingAuthorEmail, collapse = ",")
  if (CorrespondingAuthorEmail==""){CorrespondingAuthorEmail = NA}
  
  #PUBLICATION DATE
  PubDate = xpathSApply(doc, '//div[@class="citation-date"]/text()', xmlValue)
  if (PubDate==""){PubDate = NA}
  
  #ABSTRACT
  Abstract = xpathSApply(doc, '//section[@class="abstract"]/descendant::*/text()', xmlValue)
  Abstract = paste0(Abstract, collapse = "")
  if (Abstract==""){Abstract = NA}
  
  #KEYWORDS
  Keywords = xpathSApply(doc, '//a[@class="kwd-part kwd-main"]/descendant::text()', xmlValue)
  Keywords = paste0(Keywords, collapse = ",")
  if (Keywords==""){Keywords = NA}
  
  #FULL TEXT
  FullText = xpathSApply(doc, '//h2[@class="section-title"]/following-sibling::*', xmlValue)
  FullText = paste0(FullText, collapse = "")
  if (FullText==""){
    FullText = xpathSApply(doc, '//a[@class="al-link pdf article-pdfLink"]/@href')
    FullText = paste0(baseURL,FullText)
  }
  
  #RETURN ITERATION RESULT
  return(c(DOI,Title,Authors,AuthorAffiliations,
           CorrespondingAuthor,CorrespondingAuthorEmail,
           PubDate,Abstract,Keywords,FullText))
}
#HTMLPARSER FUNCTION END
#==============================================================================================#

#ALL THE FILES IN FOLDER ARTICLES
files = list.files(path = "../articles", full.names = FALSE, all.files = FALSE) 

#ITERATE OVER ALL THE FILES IN THE FOLDER ARTICLES
for(i in files){
  html = readLines(paste0("../articles/",i))
  doc = htmlParse(html, asText=TRUE)
  Comp_data[nrow(Comp_data)+1,] = htmlParser(i,doc)
}

#WRITE TO PLAIN TEXT FILE
write.table(Comp_data, file = paste0("../PlainFile/",journal_name,".txt"), sep = "\t")