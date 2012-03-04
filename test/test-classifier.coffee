vows = require('vows')
assert = require('assert')
Classifier = require('../src/classifier')



vows
    .describe('Classifier')
    .addBatch
        'a backend instance':
            topic: ->
                new Classifier.Backend()

            'incremantal feature': (topic) ->
                topic.incrementFeature('hoge', 'good')
                topic.incrementFeature('meke', 'normal')
                assert.equal topic.featureCount['hoge']['good'], 1

            'incremantal category': (topic) ->
                topic.incrementCategory('good')
                assert.equal topic.categoryCount['good'], 1

            'get feature count': (topic) ->
                assert.equal topic.getFeatureCount('fuga', 'good'), 0.0
                assert.equal topic.getFeatureCount('hoge', 'bad'), 0.0
                assert.equal topic.getFeatureCount('hoge', 'good'), 1.0

            'get category count': (topic) ->
                assert.equal topic.getCategoryCount('bad'), 0.0
                assert.equal topic.getCategoryCount('good'), 1.0

            'total count': (topic) ->
                assert.equal topic.getTotalCount(), 1.0
                topic.incrementCategory('bad')
                assert.equal topic.getTotalCount(), 2.0

            'categories': (topic) ->
                assert.deepEqual topic.getCategories(), ['good', 'bad']

    .addBatch
        'a classifier instance':
            topic: ->
                getWords = (text) ->
                    words = (word for word in text.split(/\s+/) when 2 < word.length and word.length < 20)
                    output = {}
                    output[words[key]] = words[key] for key in [0...words.length]
                    value for key, value of output
                cl = new Classifier.Classifier(getWords)
                cl.training('Nobody owns the water.','good') 
                cl.training('the quick rabbit jumps fences','good') 
                cl.training('buy pharmaceuticals now','bad') 
                cl.training('make quick money at the online casino','bad') 
                cl.training('the quick brown fox jumps','good') 
                cl

            'feature probability': (topic) ->
                assert.equal topic.getFeatureProbability('quick', 'good'), 0.6666666666666666

            'weighted probability': (topic) ->
                getProbability = (feature, category) ->
                    return 0 if topic.backend.getCategoryCount(category) == 0
                    topic.backend.getFeatureCount(feature, category) / topic.backend.getCategoryCount(category)
                assert.equal topic.getWeightedProbability('money', 'good', getProbability), 0.25


    .addBatch
        'a Fisher classifier instance':
            topic: ->
                getWords = (text) ->
                    words = (word for word in text.split(/\s+/) when 2 < word.length and word.length < 20)
                    output = {}
                    output[words[key]] = words[key] for key in [0...words.length]
                    value for key, value of output
                cl = new Classifier.FisherClassifier(getWords)
                cl.training('Nobody owns the water.','good') 
                cl.training('the quick rabbit jumps fences','good') 
                cl.training('buy pharmaceuticals now','bad') 
                cl.training('make quick money at the online casino','bad') 
                cl.training('the quick brown fox jumps','good') 
                cl


            'fisher probability': (topic) ->
                assert.equal topic.getProbability('quick rabbit', 'good'), 0.78013986588958
                assert.equal topic.getProbability('quick rabbit', 'bad'), 0.35633596283335256

            'fisher classify': (topic) ->
                assert.equal topic.classify('quick rabbit'), 'good'
                assert.equal topic.classify('quick money'), 'bad'
                topic.setMinimum('bad', 0.8)
                assert.equal topic.classify('quick money'), 'good'
                topic.setMinimum('good', 0.4)
                assert.equal topic.classify('quick money'), 'good'

    .addBatch
        'a naive Bayse classifier instance':
            topic: ->
                getWords = (text) ->
                    words = (word for word in text.split(/\s+/) when 2 < word.length and word.length < 20)
                    output = {}
                    output[words[key]] = words[key] for key in [0...words.length]
                    value for key, value of output
                cl = new Classifier.NaiveBayseClassifier(getWords)
                cl.training('Nobody owns the water.','good') 
                cl.training('the quick rabbit jumps fences','good') 
                cl.training('buy pharmaceuticals now','bad') 
                cl.training('make quick money at the online casino','bad') 
                cl.training('the quick brown fox jumps','good') 
                cl

            'naive bayse probability': (topic) ->
                assert.equal topic.getProbability('quick rabbit', 'good'), 0.15624999999999997
                assert.equal topic.getProbability('quick rabbit', 'bad'), 0.0500

            'naive bayse classify': (topic) ->
                assert.equal topic.classify('quick rabbit'), 'good'
                assert.equal topic.classify('quick money'), 'bad'
                topic.setThreshold('bad', 3.0)
                assert.equal topic.classify('quick money'), 'unknown'

    .export module

