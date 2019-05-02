#
# programmed by rick dale for comm 130 at ucla
# date: spring, 2019
#

install.packages('htm2txt')
install.packages('Rtts')
norm_vec = function(x) sqrt(sum(x^2))
removepunct = function(x) { return(gsub("[[:punct:]]","",x)) }

get_texts = function(urls) {
  print('Downloading texts. This can take a minute.')
  library(htm2txt)
  texts = c()
  for (i in 1:length(urls)) {
    this_text = tolower(gettxt(urls[i]))
    #this_text = gsub("\n"," ",this_text)
    #this_text = iconv(this_text, from = 'UTF-8', to = 'ASCII//TRANSLIT')
    texts = c(texts,removepunct(this_text))
  }
  print('Done! Raw text now stored in your variable.')
  return(texts)
}

build_term_doc_matrix = function(raw_text) {
  print('Building the term-by-document matrix. Might have to wait a minute or two. Get comfy.')
  unique_words = sort(unique(unlist(strsplit(gsub('\n',' ',raw_text),' ')))) # let's get unique word list
  nr = length(unique_words) # how many words are in that set?
  
  documents = unlist(strsplit(raw_text,'\n'))
  documents = documents[nchar(documents)>50]
  nc = length(documents) # number of documents
  
  term.X.doc = matrix(0,nrow=nr,ncol=nc) # let's initialize a term by document matrix 
  # nrow = number of words / ncol = number of documents
  
  # it's a small set so we can loop... for more complex processes, see dplyr
  # it's astonishing
  for (i in 1:nc) { 
    doc_words = unlist(strsplit(documents[i],' '))
    ixes = unlist(lapply(doc_words,function(x) { which(unique_words==x) }))
    counts = table(ixes)
    term.X.doc[as.numeric(names(counts)),i] = counts
  }
  row.names(term.X.doc) = unique_words
  colnames(term.X.doc) = paste("doc",1:nc)
  term.X.doc = term.X.doc[nchar(row.names(txd))>2,]
  term.X.doc=term.X.doc[rowSums(term.X.doc)>2,]
  term.X.doc=log(term.X.doc+1)
  term.X.doc=term.X.doc[rowSums(term.X.doc)>0,]
  print('Matrix done. Stored in the variable you set.')
  return(term.X.doc)
}

build_lsa_model = function(txd,ndims=20) {
  print('Now we run SVD to juice the data matrix into informative dimensions. Here we go. Again, might take a minute depending on the amount of text you processed.')
  svd_sol = svd(txd)
  row.names(svd_sol$u) = row.names(txd)
  print('Done! The LSA model is now stored in the variable you set.')
  return(svd_sol$u[,1:ndims])
}

cosine_compare = function(lsa_model,word_1,word_2) {
  words = row.names(lsa_model)
  if (!(word_1 %in% words)) {
    return(paste0('Sorry, the word ',word_1,' is not in the texts. This may be because it did not occur frequently enough to include in the model. Words have to be present at least 2 or more times in a single text from the data you entered.',collapse=''))
  }
  if (!(word_2 %in% words)) {
    return(paste0('Sorry, the word ',word_2,' is not in the texts. This may be because it did not occur frequently enough to include in the model. Words have to be present at least 2 or more times in a single text from the data you entered.',collapse=''))
  }
  word_1_v = lsa_model[which(words==word_1),]
  word_2_v = lsa_model[which(words==word_2),]
  cos_val = (word_1_v %*% word_2_v)/(norm_vec(word_1_v)*(norm_vec(word_2_v)))
  return(paste('The cosine between words',word_1,'and',word_2,'is',round(cos_val,2)))
}

closest_words = function(lsa_model,word_1) {
  print('Computing... this might take a hot minute...')
  words = row.names(lsa_model)
  if (!(word_1 %in% words)) {
    return(paste0('Sorry, the word ',word_1,' is not in the texts. This may be because it did not occur frequently enough to include in the model. Words have to be present at least 2 or more times in a single text from the data you entered.',collapse=''))
  }
  word_1_v = lsa_model[which(words==word_1),]
  cos_vals = c()
  for (i in 1:nrow(lsa_model)) { # faster to do matrix form; but we have a small dataset...
    word_2 = words[i]
    word_2_v = lsa_model[which(words==word_2),]
    cos_val = (word_1_v %*% word_2_v)/(norm_vec(word_1_v)*(norm_vec(word_2_v)))
    cos_vals = c(cos_vals,cos_val)
  }
  print(paste('Below are the closest words in meaning to',word_1))
  ixes = sort(cos_vals,decreasing=T,index=T)$ix
  for (i in 1:10) {
    print(paste(words[ixes[i]],'with a cosine of',round(cos_vals[ixes[i]],2)))
  }
}




