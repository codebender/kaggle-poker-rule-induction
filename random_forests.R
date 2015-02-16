# load dependencies
library(randomForest)

# load train and test data
train <- read.csv("Data/train.csv", stringsAsFactors=FALSE)
test <- read.csv("Data/test.csv", stringsAsFactors=FALSE)

set.seed(415)

fit <- randomForest(as.factor(hand) ~
  S1 + C1 + S2 + C2 + S3 + C3 + S4 + C4 + S5 + C5,
  data=train,
  ntree = 2000, mtry=9)

prediction <- predict(fit, test, type="class")

# Create submission dataframe and output to file
submit <- data.frame(id = test$id, hand = prediction)
write.csv(submit, file = "Output/random_forest_mtry9.csv", row.names = FALSE)
