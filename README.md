# your-first-lsa

The goal of this exercise is to get you setup in RStudio and run your first basic LSA model. The code below will illustrate this in a few lines. I'll also give you instructions on how to feed the code your own websites of interest, to build your own LSA model and explore. Let's break it down.

# A: Get R and RStudio

Welcome to your first LSA. Before you run this exercise, make sure you have R and RStudio setup. This part, of course, is the easiest! Go to this website and follow the instructions for your own system (Windows, etc.). Note that you have to install two things. First, install R, which is the core programming system we'll be using. Then, install RStudio, which is a very elegant user interface with point-and-click menu items to work with code in R.

[https://cran.rstudio.com/](https://cran.rstudio.com/)

[https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/#download)

Once you have this done, you should be able to open RStudio on your computer and see an interface with several different windows. If you want to get a quick tour of RStudio, consult the short videos at the ["How to R" Youtube channel](https://www.youtube.com/channel/UCAeWj0GhZ94wuvOIYu1XVrg). You probably won't need 'em. Let's keep going.

# First, install what we need

Okay, once you have RStudio going, you can install our materials using the "Console" window that should be present. The "Console," where you can type commands, has a ">" character right next to it. Click there, so you can see your cursor, and copy and paste this code line by line, hitting enter after each. 

We need to install a few things. I wrote some code to get us off the ground, and we are going to use some other libraries and functions that are part of R/RStudio. To do all this, you can just run this single line of code. It should do all for you, and you should get no errors. If you get errors, raise your hand and Rick will wander to you. (Note: if you get a warning, that's okay; it's not the same as an error. You can ignore that in most cases.)

Line 1 to run in RStudio's command console:

```r
source('https://raw.githubusercontent.com/racdale/simple-lsa-example/master/lsa_functions.R')
```

# Next, let's get some texts

In this step, we are going to "scrape" three websites to build an LSA model. These are the Wikipedia entries for "Brain," "Car," and "Communication." We are only using 3 websites, and I noted in class that LSA can uses thousands or millions of texts. We are simplifying things a bit, building a simpler model that can run easily on our personal computers. I have also added a little twist -- this line of code uses *paragraphs* from the Wikipedia websites as definitions of "documents." That means we'll get hundreds of documents from these large Wikipedia websites, rather than just 3. 

Anyway, here's line 2 to run:

```r
raw_text = get_texts(c('https://en.wikipedia.org/wiki/Brain','https://en.wikipedia.org/wiki/Car','https://en.wikipedia.org/wiki/Communication'))
```

Note that you can put any websites you like in this function, so you can build your own model, later.

# D: Build the term-by-document matrix

I have converted some code into a simple function. This way you can build a term-by-document matrix -- that grid representation discussed in class -- from a single line of code. That's it! Try this one out:

Line of code number 3:

```r
term_by_doc_matrix = build_term_doc_matrix(raw_text)
```

Below I share a series of optional lines (lines X-Y) of code you can use to explore this matrix. This will show you what is inside the matrix, where the words and documents are, and so on.

# E

We've got the word-by-document matrix. Now we are going to "squeeze" out the core information. This information will then constitute our lsa_model -- a set of smaller dimensions, giving us our word vectors. These vectors will then be compared for semantic similarity.

Line 4 is simple:

```r
lsa_model = build_lsa_model(term_by_doc_matrix)
```

# Step 6: Use the LSA model and compare words

We now have a Latent Semantic Model, encoded in the `lsa_model` variable. This is a new word-by-dimension matrix, and the dimensions now give us our nifty vectors. Let's compare some words!

# Step 7: Use the LSA model

Let's get the closest words to the word "car." This function called `closest_words` takes the LSA model and a target word "car" and gives us 20 closest related words. The most closely related is obvious... the word to itself. Remember we used cosine as our measure of interest, with higher cosine reflecting greater relationship between meanings.

Line 5 is the simplest!

```r
closest_words(lsa_model,'car')
```

Line 6 will compare two words directly... in the appendix below I offer a few other examples. You can plugin whatever words you might be interested in.

```r
cosine_compare('automobile','car')
```

# Appendix: Extra lines of code to try

What's in the word-by-document matrix? Let's take a look at the first 10 words:

```r
row.names(term_by_doc_matrix)[1:10]
```

What do the counts look like, over paragraphs? Let's look at the 101st word's raw data:

```r
term_by_doc_matrix[101,]
```

Example comparisons of other pairs of words:

```r
cosine_compare('cortex','car')
cosine_compare('shannon','communication')
cosine_compare('shannon','brains')
```



