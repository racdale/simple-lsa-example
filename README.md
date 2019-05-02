# your-first-lsa

The goal of this exercise is to get you setup in RStudio and run your first basic LSA model. The code below will illustrate this in a few lines. I'll also give you instructions on how to feed the code your own websites of interest, to build your own LSA model and explore. Let's break it down.

# Step 1: Get R and RStudio

Welcome to your first LSA. Before you run this exercise, make sure you have R and RStudio setup. This part, of course, is the easiest! Go to this website and follow the instructions for your own system (Windows, etc.). Note that you have to install two things. First, install R, which is the core programming system we'll be using. Then, install RStudio, which is a very elegant user interface with point-and-click menu items to work with code in R.

[https://cran.rstudio.com/](https://cran.rstudio.com/)

[https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/#download)

Once you have this done, you should be able to open RStudio on your computer and see an interface with several different windows. If you want to get a quick tour of RStudio, consult the short videos at the ["How to R" Youtube channel](https://www.youtube.com/channel/UCAeWj0GhZ94wuvOIYu1XVrg). You probably won't need 'em. Let's keep going.

# Step 2: Install what you need

We need to install a few things. I wrote some code to get us off the ground, and we are going to use some other libraries and functions that are part of R/RStudio. To do all this, you can just run this single line of code. It should do all for you, and you should get no errors. If you get errors, raise your hand and Rick will wander to you.

```r

```


```r

raw_text = get_texts(c('https://en.wikipedia.org/wiki/Brain','https://en.wikipedia.org/wiki/Car','https://en.wikipedia.org/wiki/Communication'))

term_by_doc_matrix = build_term_doc_matrix(raw_text)

lsa_model = build_lsa_model(term_by_doc_matrix)

closest_words(lsa_model,'car')

```

