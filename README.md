# Performing Best Model Selection on Boston Dataset using AIC,BIC, 5 fold & 10 fold Cross Validation and Bootstrap .632 estimator.
## Dataset: 
Dataset used is Boston: Housing Values in Suburbs of Boston dataset in MASS library in R. 

#### Format: 
This data frame contains the following columns:

crim
per capita crime rate by town.

zn
proportion of residential land zoned for lots over 25,000 sq.ft.

indus
proportion of non-retail business acres per town.

chas
Charles River dummy variable (= 1 if tract bounds river; 0 otherwise).

nox
nitrogen oxides concentration (parts per 10 million).

rm
average number of rooms per dwelling.

age
proportion of owner-occupied units built prior to 1940.

dis
weighted mean of distances to five Boston employment centres.

rad
index of accessibility to radial highways.

tax
full-value property-tax rate per \$10,000.

ptratio
pupil-teacher ratio by town.

black
\(1000(Bk - 0.63)^2\) where \(Bk\) is the proportion of blacks by town.

lstat
lower status of the population (percent).

medv
median value of owner-occupied homes in \$1000s.

## Libraries: 
-- ISLR <br/>
-- corrplot <br/>
-- MASS <br/>
-- klaR <br/>
-- leaps <br/>
-- lattice <br/>
-- ggplot2 <br/>
-- corrplot <br/>
-- car <br/>
-- caret <br/>
-- class <br/>
-- boot <br/>
-- bootstrap <br/>

## Best Subset Selection: 
Best subset selection is a method that aims to find the subset of independent variables (Xi) that best predict the outcome (Y) and it does so by considering
all possible combinations of independent variables.

The R function regsubsets() [leaps package] can be used to identify different best models of different sizes.

### AIC/CP: 

![AIC_ques1](https://user-images.githubusercontent.com/46763031/148007483-83b9c925-5ee7-4fe3-9bbe-d03cc18f3105.png)

![CP_ques1](https://user-images.githubusercontent.com/46763031/148007489-2e6c9090-9ece-4ee0-94aa-27a553d55249.png)

So AIC gives minimum error in model with 11 variables.

### BIC:

![BIC_ques1](https://user-images.githubusercontent.com/46763031/148007523-d24f0dd4-0b79-45d0-b965-31d8bcbe2629.png)

![BIC_cp](https://user-images.githubusercontent.com/46763031/148007548-eff8b456-3048-4c4a-90af-09ef917121d7.png)

So BIC gives minimum error in model with 9 variables

## K-Fold Cross Validation: 
The k-fold Cross-validation consists of first dividing the data into k subsets. Each subset[10%] is used as test dataset and remaining[90%]
subset serves as training dataset

### 5-fold cross validation: 
![5fold_ques1](https://user-images.githubusercontent.com/46763031/148007623-c33b59f5-1987-45cc-bd4d-3e7fe6c32437.png)

5 - fold cross validation has 11 variable model with the lowest error.

### 10- fold cross validation: 
![10fold_cross-validation](https://user-images.githubusercontent.com/46763031/148007656-1b618b91-207d-4490-9705-d6f6b5b498b7.png)

Like 5 fold cross-validation, 10 fold cross validation also gives 11 variable model with lowest error rate.

## Bootstrap .632 estimator:
![Bootstrap_Estimator_ques1](https://user-images.githubusercontent.com/46763031/148007708-6986cb81-a0fd-4c8b-99e1-a89d5974817d.png)

So, Bootstrap estimator .632 gives 12 variable model with least error rate.













