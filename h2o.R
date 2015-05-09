library(h2o)
#start an H2o cluster on local pc at with 4gs of memory and access to all cores
localh2o <- h2o.init(ip="localhost",port=54321,startH2O=T,max_mem_size='6g',nthreads = -1)
train<-read.csv("Data/train.csv")
test<-read.csv("Data/test.csv")
#load train_train to the h2o cluster with the name 'dat'

train$S1<-factor(train$S1)
train$S2<-factor(train$S2)
train$S3<-factor(train$S3)
train$S4<-factor(train$S4)
train$S5<-factor(train$S5)
train$hand<-factor(train$hand)
dat_h2o <- as.h2o(localh2o,train,key='train')

test$S1<-factor(test$S1)
test$S2<-factor(test$S2)
test$S3<-factor(test$S3)
test$S4<-factor(test$S4)
test$S5<-factor(test$S5)
sol_h2o <- as.h2o(localh2o,test,key='test')

model<-h2o.deeplearning(x= 1:10,
                        classification=T,
                        y= 11,
                        data=dat_h2o,
                        activation="RectifierWithDropout",
                        hidden_dropout_ratio=c(.2,.3,.2),
                        l1=1e-5,
                        hidden = c(500,500,500),
                        epochs = 100)

h2o_predicted<-h2o.predict(model,sol_h2o)
predicted<-as.data.frame(h2o_predicted)

sampleSubmission <- read.csv("Output/sampleSubmission.csv")
sampleSubmission$hand <- predicted$predict
write.csv(sampleSubmission,'Output/h2o.csv',row.names=F)
