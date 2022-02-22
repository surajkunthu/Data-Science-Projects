# Machine Learning with Python
## Week 1: Intro to Machine Learning
---

What is Machine Learning?

- Subfield of computer science that gives "computers the ability to learn without explicitly being programmed"
- coined by Arthur Samuel, 1959 IBM

<br>

### **Major Machine Learning Techniques**
---
1. Regression:\
    Predicting continuous values

2. Classification:\
    Predicting item class/category of a case

3. Clustering:\
    Finding structure of data; summarization

4. Associations:\
    Assoicating frequent co-occurring items/events

5. Anomaly Detection:\
Discover abnormal and unusual cases

6. Sequence Mining:\
    Predicting next events; click-streams [Markov Model, HMM]


7. Dimension Reduction:\
     Reducing the size of data (PCA)

8. Recommendation Systems:\
    Recommending items



| AI Components | Machine Learning | Revolution in Machine Learning |
| ----------- | ----------- |----------- |
| Computer Vision | Classification | Deep Learning |
| Language Processing | Clustering | |
| Creativity | Neural Network | |
| etc... | etc... | |


### Python Libraries for Machine Learning
---

**Numpy**: arrays, dictionaries, functions, datatypes, images.

**SciPy**: signal processing, optimization, statistics.

**Matplotlib**: 2D & 3D visualizations.

**Pandas**: import/export data manipulation.

**Scikit-Learn**: Machine Learning libraries.
- classification, regression, clustering algorithms
- most steps are already complete in scikit-learn

### Supervised Learning
---
"Teach the model"
Controlled environment


#### **Two types**
*Classification*: process of predicting class labels/categories.

*Regression*: proces of preducting continuous values.

### Unsupervised Learning
---
Model works on its own to discover information
Less controlled environment


Techniques:
  - Dimension Reduction
  - Density Equation
  - Market Basket Analysis
  - Clustering (most popular): grouping of data points or objects that are somehow similar
    - discovering structure
    - summarization
    - anamoly detection
    

<br>

 ## Week 2: Linear Regression
 ---
 
### What is Regression
Process of predicting a continuous value

Two Variables: Dependent (y) and independent (x) variables 


$ y = f(x) $

Two Regression Models:
- *Simple*: one x & one y
    - Linear
    - Non-linear

- *Multiple*: more than one x
    - Linear
    - Non-linear


Many regression algorithms
- Ordinal
- Poisson
- Fast forest quantile
- Linear, Polynomail, Lasso, Step-wise, Ridge
- Bayesian
- Neural Network
- Decision Forest
- Boosted Decision Tree
- KNN (K-nearest neighbor)

<br>

### Simple Linear Regression
----


> $ \hat{y} = \theta_0 +\theta_1x_1 $

$ \hat{y}$ : Response variable

$\theta_0$: Intervept

$\theta_1$: Slope

$x_1$: Single predictor

Residual error $= y - \hat{y} $

Mean Square Error, MSE = $ \frac{1}{n}\sum^n_{i = 1} (y_i - \hat{y}_i)^2  $ 
- We want to minimize this error


$ \theta_1 = \frac{\sum^s_{i = 1} (x_i - \bar{x}_i) (y_i - \bar{y}_i)}{(x_i - \bar{x}_i)^2} $


Bias Coefficient : $ \theta_0 = \bar{y} - \theta_1 \bar{x} $


Pros of Linear Regression:
- Very Fast
- No parameter tuning

#### Model Evaluation in Regression Models
----
Two Models:
1. Train & test, on the same dataset
2. Train/Test split



#### Evaluation Metrics in Regression Models
----

- Mean Absolute Error, MAE = $ \sum^n_{j = 1} |y_j - \hat{y}_j|  $ 

- Mean Square Error, MSE = $ \frac{1}{n}\sum^n_{i = 1} (y_i - \hat{y}_i)^2  $ 

- Root Mean Squared Error, RMSE = $ \sqrt{\frac{1}{n}\sum^n_{i = 1} (y_i - \hat{y}_i)^2} $
    - $ \sqrt{MSE} $

- Relative Absolute Error, RAE = $ \frac{\sum^n_{j = 1} |y_j - \hat{y}_j| }{ \sum^n_{j = 1} |y_j - \bar{y}| }$

- Relative Squared Error, RSE = $ \frac{\sum^n_{i = 1} (y_i - \hat{y}_i)^2 }{\sum^n_{i = 1} (y_i - \bar{y})^2 } $
    - $R^2 = 1 - RSE$

#### Lab: Simple Linear Regression
---
- Use scikit-learn to implement simple Linear Regression
- Create a model, train it, test it and use the model

```
# Import necessary packages
import matplotlib.pyplot as plt
import pandas as pd
import pylab as pl
import numpy as np
%matplotlib inline

# Download data
!wget -O FuelConsumption.csv https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-ML0101EN-SkillsNetwork/labs/Module%202/data/FuelConsumptionCo2.csv
```

Understanding the Data

We have downloaded a fuel consumption dataset, **`FuelConsumption.csv`**, which contains model-specific fuel consumption ratings and estimated carbon dioxide emissions for new light-duty vehicles for retail sale in Canada. [Dataset source](http://open.canada.ca/data/en/dataset/98f1a129-f628-4ce4-b24d-6f16bf24dd64?utm_medium=Exinfluencer&utm_source=Exinfluencer&utm_content=000026UJ&utm_term=10006555&utm_id=NA-SkillsNetwork-Channel-SkillsNetworkCoursesIBMDeveloperSkillsNetworkML0101ENSkillsNetwork20718538-2021-01-01)

*   **MODELYEAR** e.g. 2014
*   **MAKE** e.g. Acura
*   **MODEL** e.g. ILX
*   **VEHICLE CLASS** e.g. SUV
*   **ENGINE SIZE** e.g. 4.7
*   **CYLINDERS** e.g 6
*   **TRANSMISSION** e.g. A6
*   **FUEL CONSUMPTION in CITY(L/100 km)** e.g. 9.9
*   **FUEL CONSUMPTION in HWY (L/100 km)** e.g. 8.9
*   **FUEL CONSUMPTION COMB (L/100 km)** e.g. 9.2
*   **CO2 EMISSIONS (g/km)** e.g. 182   --> low --> 0

```
# READ IN THE DATASET
df = pd.read_csv("FuelConsumption.csv")

# View head of dataset
df.head()

# summarize the data
df.describe()

# Let's select some features to explore more.
cdf = df[['ENGINESIZE','CYLINDERS','FUELCONSUMPTION_COMB','CO2EMISSIONS']]
cdf.head(9)

# Plot features
viz = cdf[['CYLINDERS','ENGINESIZE','CO2EMISSIONS','FUELCONSUMPTION_COMB']]
viz.hist()
plt.show()

# Plot fuel consumption against emission
plt.scatter(cdf.FUELCONSUMPTION_COMB, cdf.CO2EMISSIONS,  color='blue')
plt.xlabel("FUELCONSUMPTION_COMB")
plt.ylabel("Emission")
plt.show()

# Plot engine size against emission
plt.scatter(cdf.ENGINESIZE, cdf.CO2EMISSIONS,  color='blue')
plt.xlabel("Engine size")
plt.ylabel("Emission")
plt.show()

```
Train/Test Split involves splitting the dataset into training and testing sets that are mutually exclusive. After which, you train with the training set and test with the testing set.
This will provide a more accurate evaluation on out-of-sample accuracy because the testing dataset is not part of the dataset that have been used to train the model. Therefore, it gives us a better understanding of how well our model generalizes on new data.

This means that we know the outcome of each data point in the testing dataset, making it great to test with! Since this data has not been used to train the model, the model has no knowledge of the outcome of these data points. So, in essence, it is truly an out-of-sample testing.

Let's split our dataset into train and test sets. 80% of the entire dataset will be used for training and 20% for testing. We create a mask to select random rows using **np.random.rand()** function:

```
msk = np.random.rand(len(df)) < 0.8
train = cdf[msk]
test = cdf[~msk]
```
Simple Regression Model: Linear Regression fits a linear model with coefficients B = (B1, ..., Bn) to minimize the 'residual sum of squares' between the actual value y in the dataset, and the predicted value yhat using linear approximation.


```
# Train data distrubtion
plt.scatter(train.ENGINESIZE, train.CO2EMISSIONS,  color='blue')
plt.xlabel("Engine size")
plt.ylabel("Emission")
plt.show()


# Modeling
from sklearn import linear_model
regr = linear_model.LinearRegression()
train_x = np.asanyarray(train[['ENGINESIZE']])
train_y = np.asanyarray(train[['CO2EMISSIONS']])
regr.fit(train_x, train_y)
# The coefficients
print ('Coefficients: ', regr.coef_)
print ('Intercept: ',regr.intercept_)
```

As mentioned before, Coefficient and Intercept in the simple linear regression, are the parameters of the fit line. Given that it is a simple linear regression, with only 2 parameters, and knowing that the parameters are the intercept and slope of the line, sklearn can estimate them directly from our data. Notice that all of the data must be available to traverse and calculate the parameters.

```
# Plot outputs
plt.scatter(train.ENGINESIZE, train.CO2EMISSIONS,  color='blue')
plt.plot(train_x, regr.coef_[0][0]*train_x + regr.intercept_[0], '-r')
plt.xlabel("Engine size")
plt.ylabel("Emission"
```
**Evaluation**: \
We compare the actual values and predicted values to calculate the accuracy of a regression model. Evaluation metrics provide a key role in the development of a model, as it provides insight to areas that require improvement.

There are different model evaluation metrics, lets use MSE here to calculate the accuracy of our model based on the test set:

*   Mean Absolute Error: It is the mean of the absolute value of the errors. This is the easiest of the metrics to understand since it’s just average error.

*   Mean Squared Error (MSE): Mean Squared Error (MSE) is the mean of the squared error. It’s more popular than Mean Absolute Error because the focus is geared more towards large errors. This is due to the squared term exponentially increasing larger errors in comparison to smaller ones.

*   Root Mean Squared Error (RMSE).

*   R-squared is not an error, but rather a popular metric to measure the performance of your regression model. It represents how close the data points are to the fitted regression line. The higher the R-squared value, the better the model fits your data. The best possible score is 1.0 and it can be negative (because the model can be arbitrarily worse).

```
from sklearn.metrics import r2_score

test_x = np.asanyarray(test[['ENGINESIZE']])
test_y = np.asanyarray(test[['CO2EMISSIONS']])
test_y_ = regr.predict(test_x)

print("Mean absolute error: %.2f" % np.mean(np.absolute(test_y_ - test_y)))
print("Residual sum of squares (MSE): %.2f" % np.mean((test_y_ - test_y) ** 2))
print("R2-score: %.2f" % r2_score(test_y , test_y_) )
```


<br>

### Multiple Linear Regression
---

> $ \hat{y} = \theta_0 + \theta_1 x_1 + \theta_2 x_2 +...+ \theta_nx_n$

Dot product: $\hat{y} = \theta^T X $ 

$ \theta^T = [\theta_0, \theta_1, \theta_2, ... ] $

$ X = \begin{bmatrix} 1 \\ x_1 \\ x_2 \\ ...\end{bmatrix} $

<br>

#### Lab: Multiple Linear Regression
---
Using the same dataset from previous lab

Multiple Regression Model:\
In reality, there are multiple variables that impact the co2emission. When more than one independent variable is present, the process is called multiple linear regression. An example of multiple linear regression is predicting co2emission using the features FUELCONSUMPTION_COMB, EngineSize and Cylinders of cars. The good thing here is that multiple linear regression model is the extension of the simple linear regression model.

```
from sklearn import linear_model
regr = linear_model.LinearRegression()
x = np.asanyarray(train[['ENGINESIZE','CYLINDERS','FUELCONSUMPTION_COMB']])
y = np.asanyarray(train[['CO2EMISSIONS']])
regr.fit (x, y)
# The coefficients
print ('Coefficients: ', regr.coef_)
```

As mentioned before, **Coefficient** and **Intercept**  are the parameters of the fitted line.
Given that it is a multiple linear regression model with 3 parameters and that the parameters are the intercept and coefficients of the hyperplane, sklearn can estimate them from our data. Scikit-learn uses plain Ordinary Least Squares method to solve this problem.

Ordinary Least Squares (OLS)

OLS is a method for estimating the unknown parameters in a linear regression model. OLS chooses the parameters of a linear function of a set of explanatory variables by minimizing the sum of the squares of the differences between the target dependent variable and those predicted by the linear function. In other words, it tries to minimizes the sum of squared errors (SSE) or mean squared error (MSE) between the target variable (y) and our predicted output ($\hat{y}$) over all samples in the dataset.

OLS can find the best parameters using of the following methods:

*   Solving the model parameters analytically using closed-form equations
*   Using an optimization algorithm (Gradient Descent, Stochastic Gradient Descent, Newton’s Method, etc.)

```
# Prediction
y_hat= regr.predict(test[['ENGINESIZE','CYLINDERS','FUELCONSUMPTION_COMB']])
x = np.asanyarray(test[['ENGINESIZE','CYLINDERS','FUELCONSUMPTION_COMB']])
y = np.asanyarray(test[['CO2EMISSIONS']])
print("Residual sum of squares: %.2f"
      % np.mean((y_hat - y) ** 2))

# Explained variance score: 1 is perfect prediction
print('Variance score: %.2f' % regr.score(x, y))
```

**Explained variance regression score:**\
Let $\hat{y}$ be the estimated target output, y the corresponding (correct) target output, and Var be the Variance (the square of the standard deviation). Then the explained variance is estimated as follows:

$\texttt{explainedVariance}(y, \hat{y}) = 1 - \frac{Var{ y - \hat{y}}}{Var{y}}$\
The best possible score is 1.0, the lower values are worse.


```
regr = linear_model.LinearRegression()
x = np.asanyarray(train[['ENGINESIZE','CYLINDERS','FUELCONSUMPTION_CITY','FUELCONSUMPTION_HWY']])
y = np.asanyarray(train[['CO2EMISSIONS']])
regr.fit (x, y)
print ('Coefficients: ', regr.coef_)
y_= regr.predict(test[['ENGINESIZE','CYLINDERS','FUELCONSUMPTION_CITY','FUELCONSUMPTION_HWY']])
x = np.asanyarray(test[['ENGINESIZE','CYLINDERS','FUELCONSUMPTION_CITY','FUELCONSUMPTION_HWY']])
y = np.asanyarray(test[['CO2EMISSIONS']])
print("Residual sum of squares: %.2f"% np.mean((y_ - y) ** 2))
print('Variance score: %.2f' % regr.score(x, y))
```
<br>

## Non-Linear Regresion
---


#### Lab: Polynomial Regression
---

Use the same data set


Polynomial Regression:\
Sometimes, the trend of data is not really linear, and looks curvy. In this case we can use Polynomial regression methods. In fact, many different regressions exist that can be used to fit whatever the dataset looks like, such as quadratic, cubic, and so on, and it can go on and on to infinite degrees.

In essence, we can call all of these, polynomial regression, where the relationship between the independent variable x and the dependent variable y is modeled as an nth degree polynomial in x. Lets say you want to have a polynomial regression (let's make 2 degree polynomial):

$$y = b + \theta_1  x + \theta_2 x^2$$

Now, the question is: how we can fit our data on this equation while we have only x values, such as **Engine Size**?
Well, we can create a few additional features: 1, $x$, and $x^2$.

**PolynomialFeatures()** function in Scikit-learn library, drives a new feature sets from the original feature set. That is, a matrix will be generated consisting of all polynomial combinations of the features with degree less than or equal to the specified degree. For example, lets say the original feature set has only one feature, *ENGINESIZE*. Now, if we select the degree of the polynomial to be 2, then it generates 3 features, degree=0, degree=1 and degree=2:

```
from sklearn.preprocessing import PolynomialFeatures
from sklearn import linear_model
train_x = np.asanyarray(train[['ENGINESIZE']])
train_y = np.asanyarray(train[['CO2EMISSIONS']])

test_x = np.asanyarray(test[['ENGINESIZE']])
test_y = np.asanyarray(test[['CO2EMISSIONS']])


poly = PolynomialFeatures(degree=2)
train_x_poly = poly.fit_transform(train_x)
train_x_poly
```
**fit_transform** takes our x values, and output a list of our data raised from power of 0 to power of 2 (since we set the degree of our polynomial to 2).

The equation and the sample example is displayed below.

$
\begin{bmatrix} 
v_1 \\ 
v_2 \\ 
\vdots \\
 v_n 
 \end{bmatrix} \longrightarrow \begin{bmatrix}
 1 & v_1 & v_1^2 \\
 1 & v_2 & v_2^2 \\
\vdots & \vdots & \vdots \\
 1 & v_n & v_n^2
\end{bmatrix}
$

$
\begin{bmatrix}
2. \\
2.4 \\
1.5 \\
\vdots
\end{bmatrix} \longrightarrow \begin{bmatrix}
 1 & 2. & 4. \\
1 & 2.4 & 5.76 \\
1 & 1.5 & 2.25 \\
\vdots & \vdots & \vdots \\
\end{bmatrix}
$

It looks like feature sets for multiple linear regression analysis, right? Yes. It Does.
Indeed, Polynomial regression is a special case of linear regression, with the main idea of how do you select your features. Just consider replacing the  $x$ with $x\_1$, $x\_1^2$ with $x\_2$, and so on. Then the 2nd degree equation would be turn into:

$$y = b + \theta_1  x\_1 + \theta_2 x\_2$$

Now, we can deal with it as a 'linear regression' problem. Therefore, this polynomial regression is considered to be a special case of traditional multiple linear regression. So, you can use the same mechanism as linear regression to solve such problems.

so we can use **LinearRegression()** function to solve it:
```
clf = linear_model.LinearRegression()
train_y_ = clf.fit(train_x_poly, train_y)
# The coefficients
print ('Coefficients: ', clf.coef_)
print ('Intercept: ',clf.intercept_)
```

As mentioned before, **Coefficient** and **Intercept** , are the parameters of the fit curvy line.
Given that it is a typical multiple linear regression, with 3 parameters, and knowing that the parameters are the intercept and coefficients of hyperplane, sklearn has estimated them from our new set of feature sets. Lets plot it:

```
plt.scatter(train.ENGINESIZE, train.CO2EMISSIONS,  color='blue')
XX = np.arange(0.0, 10.0, 0.1)
yy = clf.intercept_[0]+ clf.coef_[0][1]*XX+ clf.coef_[0][2]*np.power(XX, 2)
plt.plot(XX, yy, '-r' )
plt.xlabel("Engine size")
plt.ylabel("Emission")
```

Evaluation:
```
from sklearn.metrics import r2_score

test_x_poly = poly.transform(test_x)
test_y_ = clf.predict(test_x_poly)

print("Mean absolute error: %.2f" % np.mean(np.absolute(test_y_ - test_y)))
print("Residual sum of squares (MSE): %.2f" % np.mean((test_y_ - test_y) ** 2))
print("R2-score: %.2f" % r2_score(test_y,test_y_ ) )
```

<br>

#### Lab: Non-linear Regression
---


## Week 3: Introduction to Classification
---
