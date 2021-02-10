####################################
# Suraj Kunthu                     #
####################################


import pandas as pd # imports Pandas and assigns it as pd
import numpy as np  # imports Numpy and assigns it as pd
import matplotlib.pyplot as plt # imports the plot library and assigns it as pd 
from numpy import cov # import cov from numpy library
from scipy import stats # import stats from scipy library
from scipy.stats import pearsonr # import pearsonr from scipy.stats library
from scipy.stats import spearmanr # import spearmanr from scipy.stats library
from sklearn.linear_model import LinearRegression # import LinearRegression from sklearn.linear_model library
import statsmodels.formula.api as smf # imports statsmodels.formula.api and assigns is as smf
import seaborn as sns;sns.set(color_codes=True) # imports Seaborn and assigns it as sns as well as its color codes

print("---------------------------")
print("Suraj Kunthu")
print("---------------------------")
print()


# In addition to the 2 datasets provided via BlackBoard, I went ahead and utilized the 3 datasets from the GitHub to provide additional analysis.
# This served me well as some of the problems in this assignment required the recovered dataset as well.


print("The purpose of this project is to demonstrate Python Data Science Skills on a real-world event: Coronavirus")
print()

# Module 1: Wrangling and Describing Dataframe Properties
print("===================== Module 1 =====================")
# 1. Import all 3 datasets as dataframes utilizing pd.read.csv()
print("Question 01")
print("Import the 3 datasets as dataframes")
print("confirm = pd.read_csv('time_series_covid19_confirmed_global.csv')")
confirm = pd.read_csv('time_series_covid19_confirmed_global.csv')
print("death = pd.read_csv('time_series_covid19_deaths_global.csv')")
death = pd.read_csv('time_series_covid19_deaths_global.csv')
print("recovered = pd.read_csv('time_series_covid19_recovered_global.csv')")
recovered = pd.read_csv('time_series_covid19_recovered_global.csv')

# To simplify calling columns, replace column names with '/' to a '_' ... this helped me later on in the program to subset the data.
confirm.columns = confirm.columns.str.replace('/','_')
death.columns = death.columns.str.replace('/','_')
recovered.columns = recovered.columns.str.replace('/','_')

# 2. Show the header of each dataset
print("Question 02")
print(f'\n ------ Print Header Information for Confirmed ------')
print(confirm.head())
print()
print(f'\n ------ Print Header Information for Deaths ------')
print(death.head())
print()
print(f'\n ------ Print Header Information for Recovered ------')
print(recovered.head())
print()

# 3. Show the top three lines of each dataset
print("Question 03")
print(f'\n ------ Print First 3 lines for Confirmed ------')
print(confirm.head(3))
print()
print(f'\n ------ Print First 3 lines for Deaths ------')
print(death.head(3))
print()
print(f'\n ------ Print First 3 lines for Recovered ------')
print(recovered.head(3))
print()

# 4. Show the last three lines of each dataset
print("Question 04")
print(f'\n ------ Print Last 3 lines for Confirmed ------')
print(confirm.tail(3))
print()
print(f'\n ------ Print Last 3 lines for Deaths------')
print(death.tail(3))
print()
print(f'\n ------ Print Last 3 lines for Recovered------')
print(recovered.tail(3))
print()

# 5. What are the dimensions of each dataset
print("Question 05")
print("Number of rows x columns in Confirmed:", confirm.shape)
print()
print("Number of rows x columns in Deaths:", death.shape)
print()
print("Number of rows x columns in Recovered:", recovered.shape)
print()

# 6. Check for missing values and report the number in each dataset
print("Question 06")
print(f'\n ------ Missing values in Confirmed ------')
print(confirm.isnull().sum())
print()
print(f'\n ------ Missing values in Deaths ------')
print(death.isnull().sum())
print()
print(f'\n ------ Missing values in Recovered ------')
print(recovered.isnull().sum())
print()

# 7. Assuming that data was missing, how would you handle the case where data was
# missing?
print("Question 07")
print("If data was missing from the dataset, I would replace it with a NaN value or Unreported.")
print()

# 8. Some of the countries have multiple regions reported. For example, the US is reported
# by state. Other countries by different regions.
print("Question 08")
print()

#   a. Report how many countries have this problem
# The datasets were parsed through their "Country/Region" and the number of uniques were counted.
print("Question 08a")
print("Number of Countries that have this problem in recovered", confirm.Country_Region.value_counts().nunique())
print()
print("Number of Countries that have this problem in deaths", death.Country_Region.value_counts().nunique())
print()
print("Number of Countries that have this problem in deaths", recovered.Country_Region.value_counts().nunique())
print()

#   b. Create new dataframes that contain the total number of confirmed, deaths and
#   recovered and not the data broken down by regions. That is, if you have data –
#   say from northern France and southern France, you will add those two lines of
#   data together and call it France. Call these new data frames newcomfirmed,
#   newdead and newrecovered.
print("Question 08b")
newconfirmed = confirm.groupby("Country_Region").sum()
newdead = death.groupby("Country_Region").sum()
newrecovered = recovered.groupby("Country_Region").sum()

#   c. Using these new datasets. Repeat steps 3-6 and report the results
print("Question 08c")
print(f'\n ------ Print First 3 lines for New Confirmed ------')
print(newconfirmed.head(3))
print()
print(f'\n ------ Print First 3 lines for New Deaths ------')
print(newdead.head(3))
print()
print(f'\n ------ Print First 3 lines for New Recovered ------')
print(newrecovered.head(3))
print()

print(f'\n ------ Print Last 3 lines for New Confirmed ------')
print(newconfirmed.tail(3))
print()
print(f'\n ------ Print Last 3 lines for New Deaths ------')
print(newdead.tail(3))
print()
print(f'\n ------ Print Last 3 lines for New Recovered ------')
print(newrecovered.tail(3))
print()

print("Number of rows x columns in new Confirmed:", newconfirmed.shape)
print()
print("Number of rows x columns in new Deaths:", newdead.shape)
print()
print("Number of rows x columns in new recovered:", newrecovered.shape)
print()

print(f'\n ------ Missing values in New Confirmed ------')
print(newconfirmed.isnull().sum())
print()
print(f'\n ------ Missing values in New Deaths ------')
print(newdead.isnull().sum())
print()
print(f'\n ------ Missing values in New Recovered ------')
print(newrecovered.isnull().sum())
print()

# 9. Make sure that all 3 datasets are in alphabetical order. If they already are, just state
# that fact. Make sure that when you put them in alphabetical order, that you carry all of
# the variables along all of the column values with the reordering.
print("Question 09")
print("Datasets are already in alphabetical order")
print()

# 10. For each of the “new” dataframes, report what the types are for each variable.
print("Question 10")
print("Types of Variables in New Confirmed")
print(newconfirmed.dtypes)
print()
print("Types of Variables in New Dead")
print(newdead.dtypes)
print()
print("Types of Variables in New Recovered")
print(newrecovered.dtypes)


# 11. Lastly, create the following new cumulative data frames for the US, France and Italy.
# What you are creating is a running day-to-day total. So, let’s say that day 1 had 3
# people, day 2 had 4 people and day 3 had 6 people. Then day 1 value is 3, day 2 value
# is 3+4=7 and day 3 value is 3+4+6=13.
print("Question 11")
print()

# a. For each country, you will create 3 new dataframes called cum_country_name_
# deaths, cum_country_name_recovered and cum_country_name_confirmed.
# b. Make sure that you are creating these from your previous dataframes and not
# the original dataframe.  
print("Question 11a & 11b")

# This was found by first applying an index location function (.loc()) to isolate the desired country.
# Then, the unnecessary columns, "Lat" and "Long", were removed so that the cumulative sum function did not account for those.

# New dataframes for US with the cumulative sum
cum_US_confirmed = newconfirmed.loc[['US'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)
cum_US_deaths = newdead.loc[['US'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)
cum_US_recovered = newrecovered.loc[['US'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)

# New dataframes for France with the cumulative sum
cum_France_confirmed = newconfirmed.loc[['France'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)
cum_France_deaths = newdead.loc[['France'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)
cum_France_recovered = newrecovered.loc[['France'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)

# New dataframes for Italy with the cumulative sum
cum_Italy_confirmed = newconfirmed.loc[['Italy'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)
cum_Italy_deaths = newdead.loc[['Italy'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)
cum_Italy_recovered = newrecovered.loc[['Italy'], :].drop(columns = ["Lat", "Long"]).cumsum(axis = 1)
print()



# Module 2: Statistical Analyses
print("===================== Module 2 =====================")
# 12. For Thailand, Singapore and Malaysia report:
print("Question 12")
print()

# Much like the previous question, this was found by first applying an index location function (.loc()) to isolate the desired country.
# Then, the unnecessary columns, "Lat" and "Long", were removed so that the mean, std, and var functions did not account for those.


#   a. The mean number/day of confirmed, recovered and deaths.
print("Question 12a")
print("Thailand Means:")
print("Mean number of confirmed in Thailand:", newconfirmed.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print("Mean number of deaths in Thailand:", newdead.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print("Mean number of recovered in Thailand:", newrecovered.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print()
print("Singapore Means:")
print("Mean number of confirmed in Singapore:", newconfirmed.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print("Mean number of deaths in Singapore:", newdead.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print("Mean number of recovered in Singapore:", newrecovered.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print()
print("Malaysia Means:")
print("Mean number of confirmed in Malaysia:", newconfirmed.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print("Mean number of deaths in Malaysia:", newdead.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print("Mean number of recovered in Malaysia:", newrecovered.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).mean(axis = 1))
print()

#   b. The standard deviation of confirmed, recovered and deaths
print("Question 12b")
print("Thailand Standard Deviation:")
print("Standard Deviation of confirmed in Thailand:", newconfirmed.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print("Standard Deviation of deaths in Thailand:", newdead.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print("Standard Deviation of recovered in Thailand:", newrecovered.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print()
print("Singapore Standard Deviation:")
print("Standard Deviation of confirmed in Singapore:", newconfirmed.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print("Standard Deviation of deaths in Singapore:", newdead.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print("Standard Deviation of recovered in Singapore:", newrecovered.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print()
print("Malaysia Standard Deviation:")
print("Standard Deviation of confirmed in Malaysia:", newconfirmed.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print("Standard Deviation of deaths in Malaysia:", newdead.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print("Standard Deviation of recovered in Malaysia:", newrecovered.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).std(axis = 1))
print()

#   c. The variance/day of the confirmed, recovered and deaths
print("Question 12c")
print("Thailand Variance:")
print("Variance of confirmed in Thailand:", newconfirmed.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print("Variance of deaths in Thailand:", newdead.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print("Variance of recovered in Thailand:", newrecovered.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print()
print("Singapore Variance:")
print("Variance of confirmed in Singapore:", newconfirmed.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print("Variance of deaths in Singapore:", newdead.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print("Variance of recovered in Singapore:", newrecovered.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print()
print("Malaysia Variance:")
print("Variance of confirmed in Malaysia:", newconfirmed.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print("Variance of deaths in Malaysia:", newdead.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print("Variance of recovered in Malaysia:", newrecovered.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).var(axis = 1))
print()


# 13. For Singapore and Malaysia, report whether or not there is a statistically significant
# difference in the mean confirmed, recovered and deaths for these two countries. Explain
# why you are concluding what you have concluded.

# Here I utilized the pearsonr() and spearmanr() functions to determine the statistical significance on the desired country subsets 

print("Question 13")
print("Mean statistical significance for Singapore and Malaysia utilizing Pearson and Spearmans Correlation:")
print("------------------------------------------")
SingConMean = newconfirmed.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).mean()
MalConMean = newconfirmed.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).mean()
pearson_SingMalConfirmedMean_corr, _= pearsonr(SingConMean, MalConMean)
print('Pearsons correlation for Confirmed: %.3f' % pearson_SingMalConfirmedMean_corr)
spearman_SingMalConfirmedMean_corr, _= spearmanr(SingConMean,MalConMean)
print('Spearmans correlation for Confirmed: %.3f' % spearman_SingMalConfirmedMean_corr)
print()
print("There is some statistical significance as the values are not close to each other")
print()

SingDeadMean = newdead.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).mean()
MalDeadMean = newdead.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).mean()
pearson_SingMalDeadMean_corr, _= pearsonr(SingDeadMean, MalDeadMean)
print('Pearsons correlation for Deaths: %.3f' % pearson_SingMalDeadMean_corr)
spearman_SingMalDeadMean_corr, _= spearmanr(SingDeadMean,MalDeadMean)
print('Spearmans correlation for Deaths: %.3f' % spearman_SingMalDeadMean_corr)
print()
print("There is no statistical significance as the values are close to each other")
print()

SingRecovMean = newrecovered.loc[['Singapore'], :].drop(columns = ["Lat", "Long"]).mean()
MalRecovMean = newrecovered.loc[['Malaysia'], :].drop(columns = ["Lat", "Long"]).mean()
pearson_SingMalRecoveredMean_corr, _= pearsonr(SingRecovMean, MalRecovMean)
print('Pearsons correlation for Recovered: %.3f' % pearson_SingMalRecoveredMean_corr)
spearman_SingMalRecoveredMean_corr, _= spearmanr(SingRecovMean,MalRecovMean)
print('Spearmans correlation for Recovered: %.3f' % spearman_SingMalRecoveredMean_corr)
print()
print("There is no statistical significance as the values are close to each other")
print()

# 14. Is there a linear relationship between the:
print("Question 14")
print()

# Here I utilized the cov() function to determine linearity on the desired country subsets 

#   a. Confirmed in Singapore and the confirmed in Thailand. Explain your results and
#   conclusions
print("Question 14a")
SingCon = newconfirmed.loc[['Singapore'], :].drop(columns = ["Lat", "Long"])
ThaiCon = newconfirmed.loc[['Thailand'], :].drop(columns = ["Lat", "Long"])
covariance_SingThaiCon = cov(SingCon,ThaiCon)
print("Confirmed Singapore and Thailand Linear Relationship covariance = ", covariance_SingThaiCon)
print()
print("There is not a linear relationship")
print()

#   b. Deaths in Singapore and the deaths in Thailand. Explain your results and
#   conclusions
print("Question 14b")
SingDeath = newdead.loc[['Singapore'], :].drop(columns = ["Lat", "Long"])
ThaiDeath = newdead.loc[['Thailand'], :].drop(columns = ["Lat", "Long"])
covariance_SingThaiDeath = cov(SingDeath,ThaiDeath)
print("Deaths Singapore and Thailand Linear Relationship covariance = ", covariance_SingThaiDeath)
print()
print("There is a linear relationship")
print()

#   c. Recovered in Singapore and the recovered in Thailand. Explain your results and
#   conclusions
print("Question 14c")
SingRecovered = newrecovered.loc[['Singapore'], :].drop(columns = ["Lat", "Long"])
ThaiRecovered = newrecovered.loc[['Thailand'], :].drop(columns = ["Lat", "Long"])
covariance_SingThaiRecovered = cov(SingRecovered,ThaiRecovered)
print("Recovered Singapore and Thailand Linear Relationship covariance = ", covariance_SingThaiRecovered)
print()
print("There is a linear relationship")
print()

# 15. Is there a linear relationship between
print("Question 15")
print()

#   a. The confirmed in Singapore, the confirmed in Thailand as a function of the day
#   that the data was reported? So number of confirmed is your dependent variable
#   and the day is your independent variable.
print("Question 15a")
SingCon = newconfirmed.loc[['Singapore'], :].drop(columns = ["Lat", "Long"])
ThaiCon = newconfirmed.loc[['Thailand'], :].drop(columns = ["Lat", "Long"])
covariance_SingThaiCon = cov(SingCon,ThaiCon)
print("Confirmed Singapore and Thailand Linear Relationship = ", covariance_SingThaiCon)
print()
print("There is not a linear relationship")
print()


#   b. The recovered in Singapore, the recovered in Thailand as a function of the day
#   that the data was reported? So number of recovered is your dependent variable
#   and the day is your independent variable.
print("Question 15b")
SingRecovered = newrecovered.loc[['Singapore'], :].drop(columns = ["Lat", "Long"])
ThaiRecovered = newrecovered.loc[['Thailand'], :].drop(columns = ["Lat", "Long"])
covariance_SingThaiRecovered = cov(SingRecovered,ThaiRecovered)
print("Recovered Singapore and Thailand Linear Relationship = ", covariance_SingThaiRecovered)
print()
print("There is a linear relationship")
print()

#   c. The deaths in Singapore, the deaths in Thailand as a function of the day that the
#   data was reported? So number of deaths is your dependent variable and the day
#   is your independent variable.
print("Question 15c")
SingDeath = newdead.loc[['Singapore'], :].drop(columns = ["Lat", "Long"])
ThaiDeath = newdead.loc[['Thailand'], :].drop(columns = ["Lat", "Long"])
covariance_SingThaiDeath = cov(SingDeath,ThaiDeath)
print("Deaths Singapore and Thailand Linear Relationship = ", covariance_SingThaiDeath)
print()
print("There is a linear relationship")
print()

#   d. Discuss your results. 
print("Question 15d")
print("Based on the results, only in the confirmed does there not appear to be a linear relationship. It seems to be more exponential")
print()

# Module 3: Graphics and Visualization
print("===================== Module 3 =====================")
# 16. Using the dataframes created in item 11 above, create an appropriately 
# titled and axes labeled plot (with a table indicating which color is which country) as follows:]
print("Question 16")
print()

# For this problem, I utilized the dataframes from Question 11 in a different way so that the values transformed from a wide dataframe to a long dataframe.
# This made the plotting easier, so that the proper values could lie on the axis. Then each Country was plotted against the number of observations in its dataframe.
# (Which should be the same number in all of the dataframes).

#   a. For each country, create a plot from the data in the three cumulative
#   dataframes. This means I expect to see one plot from the US, one from France
#   and one from Italy. Bonus points for making them side-by-side so that all three
#   plots are at the same level.
print("Question 16a")

newcum_US_confirmed = newconfirmed.loc['US'].drop(["Lat", "Long"]).cumsum()
newcum_US_deaths = newdead.loc['US'].drop(["Lat", "Long"]).cumsum()
newcum_US_recovered = newrecovered.loc['US'].drop(["Lat", "Long"]).cumsum()
plt.plot(range(0, len(newcum_US_confirmed)), newcum_US_confirmed, '1')
plt.plot(range(0, len(newcum_US_deaths)), newcum_US_deaths, '2')
plt.plot(range(0, len(newcum_US_recovered)), newcum_US_recovered, '3')
plt.title('US Cumulative Data')
plt.xlabel('Number of Days')
plt.ylabel('Number of Observations')
plt.legend(['US Cumulative Confirmed', 'US Cumulative Deaths', "US Cumulative Recovered"])
plt.show()

newcum_France_confirmed = newconfirmed.loc['France'].drop(["Lat", "Long"]).cumsum()
newcum_France_deaths = newdead.loc['France'].drop(["Lat", "Long"]).cumsum()
newcum_France_recovered = newrecovered.loc['France'].drop(["Lat", "Long"]).cumsum()
plt.plot(range(0, len(newcum_France_confirmed)), newcum_France_confirmed, '1')
plt.plot(range(0, len(newcum_France_deaths)), newcum_France_deaths, '2')
plt.plot(range(0, len(newcum_France_recovered)), newcum_France_recovered, '3')
plt.title('France Cumulative Data')
plt.xlabel('Number of Days')
plt.ylabel('Number of Observations')
plt.legend(['France Cumulative Confirmed', 'France Cumulative Deaths', "France Cumulative Recovered"])
plt.show()

newcum_Italy_confirmed = newconfirmed.loc['Italy'].drop(["Lat", "Long"]).cumsum()
newcum_Italy_deaths = newdead.loc['Italy'].drop(["Lat", "Long"]).cumsum()
newcum_Italy_recovered = newrecovered.loc['Italy'].drop(["Lat", "Long"]).cumsum()
plt.plot(range(0, len(newcum_Italy_confirmed)), newcum_Italy_confirmed, '1')
plt.plot(range(0, len(newcum_Italy_deaths)), newcum_Italy_deaths, '2')
plt.plot(range(0, len(newcum_Italy_recovered)), newcum_Italy_recovered, '3')
plt.title('Italy Cumulative Data')
plt.xlabel('Number of Days')
plt.ylabel('Number of Observations')
plt.legend(['Italy Cumulative Confirmed', 'Italy Cumulative Deaths', "Italy Cumulative Recovered"])
plt.show()

#   b. Next, create three plots each plot containing the cumulative data from all three
#   countries. That is, plot one will have the cumulative data (say confirmed) for US,
#   France and Italy. Plot two will ha-ve the cumulative data (say recovered) for US,
#   France and Italy etc.
print("Question 16b")

plt.plot(range(0, len(newcum_US_confirmed)), newcum_US_confirmed, '1')
plt.plot(range(0, len(newcum_France_confirmed)), newcum_France_confirmed, '2')
plt.plot(range(0, len(newcum_Italy_confirmed)), newcum_Italy_confirmed, '3')
plt.title('Confirmed Cumulative Data')
plt.xlabel('Number of Days')
plt.ylabel('Number of Observations')
plt.legend(['US Cumulative Confirmed', 'France Cumulative Confirmed', "Italy Cumulative Confirmed"])
plt.show()

plt.plot(range(0, len(newcum_US_deaths)), newcum_US_deaths, '1')
plt.plot(range(0, len(newcum_France_deaths)), newcum_France_deaths, '2')
plt.plot(range(0, len(newcum_Italy_deaths)), newcum_Italy_deaths, '3')
plt.title('Deaths Cumulative Data')
plt.xlabel('Number of Days')
plt.ylabel('Number of Observations')
plt.legend(['US Cumulative Deaths', 'France Cumulative Deaths', "Italy Cumulative Deaths"])
plt.show()

plt.plot(range(0, len(newcum_US_recovered)), newcum_US_recovered, '1')
plt.plot(range(0, len(newcum_France_recovered)), newcum_France_recovered, '2')
plt.plot(range(0, len(newcum_Italy_recovered)), newcum_Italy_recovered, '3')
plt.title('Recovered Cumulative Data')
plt.xlabel('Number of Days')
plt.ylabel('Number of Observations')
plt.legend(['US Cumulative Recovered', 'France Cumulative Recovered', "Italy Cumulative Recovered"])
plt.show()
print()

#   c. Examining these figures, what can you say about the disease Covid-19?
print("Question 16c")
print("From these figures, it's obvious to say that the US has the largest number of confirmed, deaths, and recovered cases")
print("However, this data is somewhat misleading to conclude that the US has the worst cases since the population of the US greatly outnumbers both Italy and France combined.")

#   d. Create a bar chart for each country cumulative data (confirmed, recovered,
#   dead) and put the results all in one graph with the x-axis being the country
#   name all in alphabetical order.

# For a bar chart, I needed only the maximum values of each dataframe for each country as the other values do not typically appear on a barchart.
# So, a series array for each country was created with its maximum value for each group. Then, the series were combined into a dataframe to be used in a barchart.

print("Question 16d")
maxnewcum_US_confirmed = max(newcum_US_confirmed)
maxnewcum_US_deaths = max(newcum_US_deaths)
maxnewcum_US_recovered = max(newcum_US_recovered)
USbar1 = [maxnewcum_US_confirmed, maxnewcum_US_deaths, maxnewcum_US_recovered]

maxnewcum_Italy_confirmed = max(newcum_Italy_confirmed)
maxnewcum_Italy_deaths = max(newcum_Italy_deaths)
maxnewcum_Italy_recovered = max(newcum_Italy_recovered)
Italybar1 = [maxnewcum_Italy_confirmed, maxnewcum_Italy_deaths, maxnewcum_Italy_recovered]

maxnewcum_France_confirmed = max(newcum_France_confirmed)
maxnewcum_France_deaths = max(newcum_France_deaths)
maxnewcum_France_recovered = max(newcum_France_recovered)
Francebar1 = [maxnewcum_France_confirmed, maxnewcum_France_deaths, maxnewcum_France_recovered]

CountrybarIndex1 = ['US', 'Italy', 'France']

Countrybar1 = pd.DataFrame({'Confirmed': USbar1, 'Deaths':Italybar1, 'Recovered':Francebar1 }, index = CountrybarIndex1 )
Countrybar1.plot.bar(rot = 0)
plt.title('Country Cumulative Data')
plt.xlabel('Country')
plt.ylabel('Number of Observations')
plt.show()

#   e. Repeat item d above, only create a bar chart that has the three groups
#   confirmed … together rather than the countries together.
print("Question 16e")
Conbar1 = [maxnewcum_US_confirmed, maxnewcum_Italy_confirmed, maxnewcum_France_confirmed]
Deadbar2 = [maxnewcum_US_deaths, maxnewcum_Italy_deaths, maxnewcum_France_deaths]
Recovbar2 = [maxnewcum_US_recovered, maxnewcum_Italy_recovered, maxnewcum_France_recovered]

CountrybarIndex2 = ['Confirmed', 'Deaths', 'Recovered']
Countrybar1 = pd.DataFrame({'US':Conbar1 , 'Italy':Deadbar2, 'France':Recovbar2}, index = CountrybarIndex2 )
Countrybar1.plot.bar(rot = 0)
plt.title('Country Cumulative Data')
plt.xlabel('Group')
plt.ylabel('Number of Observations')
plt.show()

#   f. Examining these three charts, what might you tell your epidemiologist friends?
print("Question 16f")
print("Much like with the scatterplots I would tell my epidemiologist friends, it's obvious to say that the US has the largest number of confirmed, deaths, and recovered cases")
print("However, this data is somewhat misleading to conclude that the US has the worst cases since the population of the US greatly outnumbers both Italy and France combined.")
print()

# 17. In item 15 above, you performed some linear analyses. Create three plots, one
# confirmed, one for deaths and one for recovered. Each plot should show the regression
# line for each of the fits and the associated data scatter. More clearly, your first plot (and
# the others as well) should contain a graph of the regression line for Singapore fit and
# one for Thailand fit, the data scatter for each of them, all appropriately labeled and
# colored with the data table that explains the colors that you used.
print("Question 17")


# Much like with Question 15, the values for Thailand needed to be created.
# Then, the linear regression was found with the stats.linregress() function.

# Singapore and Thailand Confirmed
ThaiConMean = newconfirmed.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).mean()

slope, intercept, r_value, p_value, std_err = stats.linregress( SingConMean, ThaiConMean )

plt.scatter( SingConMean, ThaiConMean )
plt.plot( SingConMean, intercept + slope*SingConMean, 'red', label='Singapore Confirmed fitted line')
plt.plot( ThaiConMean, intercept + slope*ThaiConMean, 'green', label='Thailand Confirmed fitted line')
plt.title('Singapore and Thailand Confirmed')
plt.xlabel('Singapore Confirmed')
plt.ylabel('Thailand Confirmed')
plt.legend()
plt.show()

# Singapore and Thailand Deaths
ThaiDeadMean = newdead.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).mean()

slope, intercept, r_value, p_value, std_err = stats.linregress( SingDeadMean, ThaiDeadMean )

plt.scatter( SingDeadMean, ThaiDeadMean )
plt.plot( SingDeadMean, intercept + slope*SingDeadMean, 'red', label='Singapore Deaths fitted line')
plt.plot( ThaiDeadMean, intercept + slope*ThaiDeadMean, 'green', label='Thailand Deaths fitted line')
plt.title('Singapore and Thailand Deaths')
plt.xlabel('Singapore Deaths')
plt.ylabel('Thailand Deaths')
plt.legend()
plt.show()

# Singapore and Thailand Recovered
ThaiRecovMean = newrecovered.loc[['Thailand'], :].drop(columns = ["Lat", "Long"]).mean()

slope, intercept, r_value, p_value, std_err = stats.linregress( SingRecovMean, ThaiRecovMean )

plt.scatter( SingRecovMean, ThaiRecovMean )
plt.plot( SingRecovMean, intercept + slope*SingRecovMean, 'red', label='Singapore Recovered fitted line')
plt.plot( ThaiRecovMean, intercept + slope*ThaiRecovMean, 'green', label='Thailand Recovered fitted line')
plt.title('Singapore and Thailand Recovered')
plt.xlabel('Singapore Recovered')
plt.ylabel('Thailand Recovered')
plt.legend()
plt.show()


print('\n --------------------------- END OF PROGRAM -----------------')







