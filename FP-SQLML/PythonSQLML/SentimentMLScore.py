import numpy
import pandas
from microsoftml import rx_logistic_regression, rx_featurize, rx_predict, get_sentiment, categorical



#categorical_data = pandas.DataFrame(data=dict(places_visited=[
#                "London", "Brunei", "London", "Paris", "Seria"]),
#                dtype="category")

#print(categorical_data)

## Invoke the categorical transform
#categorized = rx_featurize(data=categorical_data,
#                           ml_transforms=[categorical(cols=dict(xdatacat="places_visited"))])

## Now let's look at the data
#print(categorized)

# Create the data
customer_reviews = pandas.DataFrame(data=dict(review=[
            ""]))

## Get the sentiment scores
sentiment_scores = rx_featurize(
    data=customer_reviews,
    ml_transforms=[get_sentiment(cols=dict(scores="review"))])

# Let's translate the score to something more meaningful
#sentiment_scores["eval"] = sentiment_scores.scores.apply(
#            lambda score: "AWESOMENESS" if score > 0.6 else "BLAH")
#print(sentiment_scores)
