#
# programmed by rick dale for comm 130 at ucla
# date: spring, 2019
#

install.packages('htm2txt')
install.packages('Rtts')
install.packages('audio')
install.packages('english')
norm_vec = function(x) sqrt(sum(x^2))
removepunct = function(x) { return(gsub("[[:punct:]]","",x)) }

play_audio = function(output,destfile) {
  library(Rtts)
  tts_ITRI(output,destfile=destfile,speaker="Bruce")
  w = load.wave(destfile)
  play(w)
}

get_texts = function(urls,speak_output=F,destfile='/Users/rickdale/temp.wav') {
  library(audio)
  library(Rtts)
  library(htm2txt)
  output = 'Downloading texts. This can take a minute.'
  print(output)
  if (speak_output) {
    play_audio(output,destfile)
  }
  texts = c()
  for (i in 1:length(urls)) {
    this_text = tolower(gettxt(urls[i]))
    #this_text = gsub("\n"," ",this_text)
    #this_text = iconv(this_text, from = 'UTF-8', to = 'ASCII//TRANSLIT')
    texts = c(texts,removepunct(this_text))
  }
  output = 'Done! Raw text now stored in your variable, left of the equal sign.'
  if (speak_output) {
    wait(6)
    play_audio(output,destfile)
  }
  print(output)
  return(texts)
}

build_term_doc_matrix = function(raw_text,speak_output=F,destfile='/Users/rickdale/temp.wav') {
  output = 'Building the term-by-document matrix. Might have to wait a minute or two.'
  if (speak_output) {
    play_audio(output,destfile)
    wait(10)
  }
  print(output)  
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
  colnames(term.X.doc) = paste("paragraph",1:nc)
  term.X.doc = term.X.doc[nchar(row.names(term.X.doc))>2,]
  term.X.doc=term.X.doc[rowSums(term.X.doc)>2,]
  term.X.doc=log(term.X.doc+1)
  term.X.doc=term.X.doc[rowSums(term.X.doc)>0,]
  output = 'Matrix done. It is now stored in the variable you set to the left of the equal sign.'
  if (speak_output) {
    wait(30)
    play_audio(output,destfile)
  }
  print(output)  
  return(term.X.doc)
}

build_lsa_model = function(txd,ndims=20,speak_output=F,destfile='/Users/rickdale/temp.wav') {
  output = 'Now we run SVD to squeeze the data matrix into informative dimensions. Might take a minute.'
  if (speak_output) {
    play_audio(output,destfile)
    wait(10)
  }
  print(output)  
  svd_sol = svd(scale(txd))
  row.names(svd_sol$u) = row.names(txd)
  output = 'Done! The LSA model is now stored in the variable you set.'
  if (speak_output) {
    wait(10)
    play_audio(output,destfile)
  }
  print(output)  
  return(svd_sol$u[,1:ndims])
}

cosine_compare = function(lsa_model,word_1,word_2,speak_output=F,destfile='/Users/rickdale/temp.wav') {
  library(english)
  words = row.names(lsa_model)
  if (!(word_1 %in% words)) {
    output = paste0('Sorry, the word ',word_1,' is not in the texts. This may be because it did not occur frequently enough to include in the model. Words have to be present at least 2 or more times in a single text from the data you entered.',collapse='')
    if (speak_output) {
      play_audio(output,destfile)
    }
    return(output)
  }
  if (!(word_2 %in% words)) {
    output = paste0('Sorry, the word ',word_2,' is not in the texts. This may be because it did not occur frequently enough to include in the model. Words have to be present at least 2 or more times in a single text from the data you entered.',collapse='')
    if (speak_output) {
      play_audio(output,destfile)
    }
    return(output)
  }
  word_1_v = lsa_model[which(words==word_1),]
  word_2_v = lsa_model[which(words==word_2),]
  cos_val = (word_1_v %*% word_2_v)/(norm_vec(word_1_v)*(norm_vec(word_2_v)))
  output = paste('The cosine between words',word_1,'and',word_2,'is',round(cos_val,2))
  return(output)
  if (speak_output) {
    output = paste('The cosine between words',word_1,'and',word_2,'is point',as.english(100*round(cos_val,2)))
    play_audio(output,destfile)
  }
}

closest_words = function(lsa_model,word_1,speak_output=F,destfile='/Users/rickdale/temp.wav') {
  library(english)
  output = 'Computing... this might take a hot minute...'
  if (speak_output) {
    play_audio(output,destfile)
  }
  print(output)
  words = row.names(lsa_model)
  if (!(word_1 %in% words)) {
    output = paste0('Sorry, the word ',word_1,' is not in the texts. This may be because it did not occur frequently enough to include in the model. Words have to be present at least 2 or more times in a single text from the data you entered.',collapse='')
    if (speak_output) {
      wait(10)
      play_audio(output,destfile)
    }
    return(output)    
  }
  word_1_v = lsa_model[which(words==word_1),]
  cos_vals = c()
  for (i in 1:nrow(lsa_model)) { # faster to do matrix form; but we have a small dataset...
    word_2 = words[i]
    word_2_v = lsa_model[which(words==word_2),]
    cos_val = (word_1_v %*% word_2_v)/(norm_vec(word_1_v)*(norm_vec(word_2_v)))
    cos_vals = c(cos_vals,cos_val)
  }
  output = paste('Below are the closest words in meaning to',word_1)
  if (speak_output) {
    wait(10)
    play_audio(output,destfile)
  }
  print(output)  
  ixes = sort(cos_vals,decreasing=T,index=T)$ix
  for (i in 1:10) {
    output = paste(words[ixes[i]],'with a cosine of',round(100*cos_vals[ixes[i]],2))
    print(output)    
    if (speak_output) {
      output = paste(words[ixes[i]],'with a cosine of point',as.english(100*round(cos_vals[ixes[i]],2)))
      library(english)
      play_audio(output,destfile)
    } 
  }
}




