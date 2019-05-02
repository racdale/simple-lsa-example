# simple-lsa-example



```r

raw_text = get_texts(c('https://en.wikipedia.org/wiki/Brain','https://en.wikipedia.org/wiki/Car','https://en.wikipedia.org/wiki/Communication'))

term_by_doc_matrix = build_term_doc_matrix(raw_text)

lsa_model = build_lsa_model(term_by_doc_matrix)

closest_words(lsa_model,'car')

```

