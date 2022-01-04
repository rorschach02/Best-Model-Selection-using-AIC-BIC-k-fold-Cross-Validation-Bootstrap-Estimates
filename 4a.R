### Clear the environment 
rm(list = ls())


### First we will set the directory of the R script 
setwd("C:/Users/anike/Desktop/Sem 1/EAS 506 Statistical Data Mining/Homework/Homework 4")


## Loading all the libraries 
library(ISLR)
library(corrplot)
library(MASS)
library(klaR)
library(leaps)
library(lattice)
library(ggplot2)
library(corrplot)
library(car)
library(caret)
library(class)
library(boot)
#install.packages("bootstrap")
library(bootstrap)



## Loading the dataset 
data("Boston")


dim(Boston)

str(Boston)

data1 <- Boston

#Checking for Null Value in the dataset:
NAmat = matrix(as.numeric(is.na(data1)) , ncol = 14)
nonNAdx = which(rowSums(NAmat) == 0)
## so no missing value as length of nonNAdx is equal to number of rows in dataset 
length(nonNAdx)
dim(data1)

#Data don't seem to have any null values in it. 


#Scatterplots:

colnames(data1)

x11()
scatterplotMatrix(~medv+crim+zn+indus+chas+nox, data=data1, main="Scatterplot Matrix with Features : medv+crim+zn+indus+chas+nox")
# scatterplot 2 and 3


#Normalizing my dataset:

normalize <- function(x) {
  (x -min(x)) / (max(x) - min(x))
  
}

summary(data1)
head(data1)
Boston_Norm <- as.data.frame(lapply(data1[1:14], normalize))
head(Boston_Norm , 4)



#Splitting in training and testing dataset: 80 - 20 split 
set.seed(1)
sample_size <- floor(0.80 * nrow(Boston_Norm))
set.seed(1)
train_indexes <- sample(seq_len(nrow(Boston_Norm)), size = sample_size)
training_data <- Boston_Norm[train_indexes ,]
testing_data <- Boston_Norm[-train_indexes ,]


#Best subset selection

boston_best_subset <- regsubsets(medv ~ . , data = training_data , nbest = 1,  really.big = TRUE , nvmax = 13) 
boston_best_subset_summary <- summary(boston_best_subset)
boston_best_subset_summary$outmat

# Plotting AIC/Cp Error 
which.min(boston_best_subset_summary$cp)
# model with 11 features has the lowest AIC error 
x11()
plot(boston_best_subset_summary$cp ,xlab=" Number of Variables ",ylab=" Cp", type="l")
points(11, boston_best_subset_summary$cp[11],col="red" , cex = 2 , pch = 20)

x11()
plot(boston_best_subset, scale = "Cp")


# Plotting BIC Error
which.min(boston_best_subset_summary$bic)
# model with 7 features has the lowest BIC error 
x11()
plot(boston_best_subset_summary$bic ,xlab=" Number of Variables ",ylab=" BIC", type="l")
points(7, boston_best_subset_summary$bic[7],col="red" , cex = 2 , pch = 20)

x11()
plot(boston_best_subset, scale = "bic")


#5 - fold cross-validation:

predict.regsubsets = function(object,newdata,id , ...){
  form = as.formula((object$call[[2]]))
  mat = model.matrix(form, newdata)
  coefi = coef(object , id = id)
  xvars = names(coefi)
  mat[,xvars]%*%coefi
  
}


set.seed(1)
k = 5

five_fold_error <- matrix(NA, k, 13)
five_fold_error

five_fold = sample(1:k, nrow(training_data), replace = TRUE)


for (i in 1:k)
{
  best_subset = regsubsets(medv~., data = training_data[five_fold!=i, ], nvmax = 13)
  
  for (j in 1:13)
  {
    predictions = predict(best_subset, training_data[five_fold==i, ], id=j)
    five_fold_error[i,j] = mean((training_data$medv[five_fold==i]-predictions)^2)
  }
  
}

five_fold_error

mse.models <- apply(five_fold_error, 2, mean)      
x11()
plot(mse.models , pch=19, type="b",xlab="Predictors",ylab="MSE errors")

#10 - fold cross - validation 
set.seed(1)
k = 10

ten_fold = sample(1:k, nrow(training_data), replace = TRUE)


ten_fold_cross = matrix(NA, k, 13)

for (i in 1:k)
{
  best_subset1 = regsubsets(medv~., data = training_data[ten_fold!=i, ], nvmax = 13)
  
  for (j in 1:13)
  {
    predictions1 = predict(best_subset1, training_data[ten_fold==i, ], id=j)
    ten_fold_cross[i,j] = mean((training_data$medv[ten_fold==i]-predictions1)^2)
  }
  
}
ten_fold_cross


mse.models1 = apply(ten_fold_cross, 2, mean)
x11()
plot(mse.models1 , pch=19, type="b",xlab="Predictors",ylab="MSE errors")


# Bootstrap .632 estimation 
beta.fit <- function(X,Y)
{
  lsfit(X,Y)
}

beta.predict<- function(fit, X)
{
  cbind(1,X)%*%fit$coef
}

sq.error<- function(Y, Yhat)
{
  (Y-Yhat)^2
}


# Creating X and Y 

X <- Boston_Norm [,1:13]
Y <- Boston_Norm [,14]
dim(X)
length(Y)

select <- boston_best_subset_summary$outmat

error_values = c()
 
for (i in 1:13){
  temp <- which(select[i,] == "*")
  res<- bootpred(X[,temp], Y, nboot = 50, theta.fit = beta.fit, theta.predict = beta.predict,  err.meas = sq.error)
  error_values <- c(error_values, res[[3]])
}

error_values
which.min(error_values)
#plotting error values 
x11()
plot(error_values , pch=19, type="b",xlab="Predictors",ylab="Bootstrap .632 Error Values")


#Comparing all the model selection methods: 
  
 
output <- data.frame(
  AIC = which.min(boston_best_subset_summary$cp),
  BIC = which.min(boston_best_subset_summary$bic),
  Five_Fold_Cross_Validation = which.min(mse.models),
  Ten_Fold_Cross_Validation = which.min(mse.models1),
  Bootstrap_632 = which.min(error_values)
)

output
