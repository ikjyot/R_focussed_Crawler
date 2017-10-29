#R SCRIPT TO READ THE DNA_Research.txt FILE CREATED DURING PARSING PHASE
Data = read.table("DNA_research.txt",sep = "\t", header = TRUE, stringsAsFactors = FALSE)
print(Data)
# DOI = Data$DOI
# Title = Data$Title
# Authors = Data$Authors
# AuthorAffiliations = Data$Author-Affiliations
# CorrespondingAuthor = Data$Corresponding-Author
# CorrespondingAuthorEmail = Data$Corresponding-Author-Email
# Publication-Date = Data$Publication-Date
# Abstracts = Data$Abstract
# Keywords = Data$Keywords
# FullText = Data$Full-Text