gewtwd()
getwd()
setwd = "C:/Users/anurag/Downloads/London-price-paid-house-price-data-since-1995-CSV"
temp = list.files(pattern = ".csv")
data(iris)
require(caret)
trans = preProcess(iris[,1:4], method=c("BoxCox", "center","scale", "pca"))
PC = predict(trans, iris[,1:4])
head(PC,3)
setwd = "C:/Users/anurag/Downloads"
data(Titanic)
head(Titanic)
Train = read.csv("titanic train.csv")
test= read.csv("test.csv")
head(train)
str(train)
table(train$Survived)
train$Survived = as.factor(train$Survived)
train$Pclass = as.factor(train$Pclass)
train$PassengerId = as.factor(train$PassengerId)
train$Age[is.na(train$Age)] = -1
require(randomForest)
rf = randomForest(Survived~., train, ntree =100)
str(train)
train$Embarked[train$Embarked ==""] = "Not Given"
table(train$Embarked)
train$Ticket = as.numeric(train$Ticket)
table(train$Cabin)
summary(train)
extractfeatures<-function(data){
  features<-c("Pclass","Sex","Age","Parch","SibSp","Fare","Embarked","Ticket")
  fea<-data[,features]
  fea$Age[is.na(fea$Age)]= -1
  fea$Fare[is.na(fea$Fare)] <- median(fea$Fare, na.rm=TRUE)
  fea$Embarked[fea$Embarked==""] = "S"
  fea$Sex      <- as.factor(fea$Sex)
  fea$Pclass<-as.factor(fea$Pclass)
  fea$Embarked <- as.factor(fea$Embarked)
  fea$Ticket = as.numeric(fea$Ticket)
  return(fea)
}
str(extractfeatures(train))
model<- randomForest(extractfeatures(train), as.factor(train$Survived), ntree = 100)
levels(test$Embarked)= levels(train$Embarked)
submission<-data.frame(PassengerId = test$PassengerId)
submission$Survived<-predict(model,extractfeatures(test))
str(extractfeatures(test))
head(submission)
write.csv(file ="Submission.csv", x = submission )
my_solution<- data.frame(PassengerId = submission$PassengerId, Survived = submission$Survived)
head(my_solution)
write.csv(my_solution, file = "my_solution.csv",row.names=FALSE)
model2<-glm(train$Survived~.,extractfeatures(train), family = binomial)
log_surv<-predict(model2,train, type = 'response')
summary(model2)
require(e1071)
numfolds = trainControl(method ="cv",number = 10)
cpGrid = expand.grid(.cp = seq(0.01,0.5,0.01))
library(caret)
