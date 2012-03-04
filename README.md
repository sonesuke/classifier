Classifier
============
This library has several classifier as following.

 - Naive Bayes Classifier
 - Fisher Classifier

Dependencies
============
None. This is made by pure coffee script.

Usage
=====
This is an example of Naive Bayes classifier.
```coffeescript
Classifier = require('/src/classifier')
getWords = (text) ->
    words = (word for word in text.split(/\s+/) when 2 < word.length and word.length < 20)
    output = {}
    output[words[key]] = words[key] for key in [0...words.length]
    value for key, value of output
cl = new Classifier.NaiveBayesClassifier(getWords)
cl.training('Nobody owns the water.','good') 
cl.classify('quick money')
```

You can use  'FisherClassifisier' instead of 'NaiveBayesClassifier'.

