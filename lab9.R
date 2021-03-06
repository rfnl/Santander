
install.packages("pROC")
install.packages("cvTools")
library(pROC)
library(cvTools)
data1 = read.csv("https://web.njit.edu/~ts336/train.csv")


rw = nrow(data1)
hf = rw/2

train = data1[1:hf,]
hf = hf+1
test = data1[hf:rw,]

model <- glm(TARGET ~.,family=binomial(link='logit'),data=train) #logit = logistic regression
fitted.results <- predict(model,newdata=test,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != test$TARGET)
paste('Accuracy',(1-misClasificError)*100)


#To find the Area Under Curve
install.packages("ROCR")
library("ROCR")
predValue <- prediction(fitted.results, test$TARGET)
perfValue <- performance(predValue, measure = "tpr", x.measure = "fpr")
plot(perfValue)
aucValue <- performance(predValue, measure = "auc")
aucValue <- aucValue@y.values[[1]]
aucValue


g = roc(TARGET~fitted.results,data=test)
plot(g)

pt = predict(model,newdata = train , type='response')
g = roc(TARGET~pt,data=train)
plot(g)



#####2###
install.packages("cvTools")

## k-fold validation with k=5 , alternate method
#mm=cvFit(model,data=train,y=fitted.results,K=5)

#print(mm)

## k-fold validation with k=5

## for more details - http://machinelearningmastery.com/how-to-estimate-model-accuracy-in-r-using-the-caret-package/
install.packages("caret")

train_control = trainControl(method="cv",number=5) # cv= cross validation , number = k = 5
grid = expand.grid(.fL=c(0), .usekernel=c(FALSE))

model = train(TARGET~.,data=data1,trControl=train_control,method="nb",tuneGrid=grid)

print(model)

cvpred = predict(model,newdata=train, type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0);
misClasificError <- mean(fitted.results != test$TARGET)
paste('Accuracy',1-misClasificError) 