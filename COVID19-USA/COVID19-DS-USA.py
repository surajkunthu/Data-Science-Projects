####################################
# Suraj Kunthu                     #
# Final Project                    #
####################################

import pandas as pd #imports Pandas and assigns the worksheet to the name  pd
from scipy import stats #imports the scipy library
import matplotlib.pyplot as plt #imports the plot library
import seaborn as sns;sns.set(color_codes=True)

print("---------------------------")
print("Suraj Kunthu")
print("---------------------------")
print()

# TASKS:
# 1) You must go online and locate a dataset (we will discuss this in class) 
#    that contains at least 1,000 records; each record containing a minimum 
#    of 5 variables. It would be best if your dataset contained some string 
#    variables, some floating point variables, some integer variables and some
#    categorical variables. If you have any questions about whether or not your
#    dataset meets the requirements, please let me know and we can discuss it. 
#    I recommend starting to look right away. The website Kaggle has a variety 
#    of datasets, as do census databases and other online databases.

# 2) Your program must contain the following sections.
#   a. Input the appropriate libraries that you will use
#   b. Read in the dataset and set up an appropriate dataframe for your project work.
#   c. Contain well-documented code so that I can understand what you are doing!


print( "Project Description: ")
print( "Since we are in weird quarantine times, I thought it would be appropriate"
      "to apply data science skills to a current real world problem: Coronavirus"
      ". This program utilizes the John Hopkins University COVID-19 dataset and it is retrieved from GitHub.")
print()
print("Link: https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/05-01-2020.csv")
print()
print("The goal of this program is the analyze the data for the United States"
      " by extracting it from the most recent dataset posted on John Hopkins GitHub."
      " At the time of this project submittal the most recent dataset was May 01, 2020."
      )

# Read in the dataset: 05-01-2020.csv
print()
print("data1 = pd.read_csv('05-01-2020.csv')" )
data1 = pd.read_csv('05-01-2020.csv')

print(f'\n ------ Print Header Information ------')
print(data1.head(5))

#  Basic properties of the dataset
print()
print("------Basic properties of the dataset (shape, existence of null variables)-------")
print()

print("Number of rows x columns in the dataframe:", data1.shape)
print()

print("Number of null entries (empty): ")
print(data1.isnull().sum())
print()

print("What kind of variable each item in the dataframe is:")
print(data1.info())           
print()

print("Non-null values in each column:")
print(data1.count())         
print()

print("Basic information on values in each column:")
print(data1.describe())       
print()

# ===========================Subsetting the data to only the United States ===========================
print("data2 = data1[data1.Country_Region == 'US']")
data2 = data1[data1.Country_Region == 'US']

print(f'\n ------ Print US Header Information ------')
print(data2.head(5))

#  Basic properties of the US dataset
print()
print("------Basic properties of the US dataset (shape, existence of null variables)-------")
print()

print("Number of rows x columns in the dataframe:", data2.shape)
print()

print("Basic information on values in each column:")
print(data2.describe())       
print()

# Subset even further to only US States and Provinces
print("Subset even further to only US States and Provinces" )
print("data3 = data2.drop(columns = ['FIPS', 'Admin2', 'Country_Region', 'Last_Update', 'Lat', 'Long_', 'Recovered', 'Active', 'Combined_Key' ]")
data3 = data2.drop(columns = ["FIPS", "Admin2", "Country_Region", "Last_Update", "Lat", "Long_", "Recovered", "Active", "Combined_Key" ])
# Change the index to the individual state and/or province
print()
print("Change the index to the individual state and/or province")
print("data4 = data3.set_index('Province_State')")
data4 = data3.set_index("Province_State")
# Group and sum up the values
print()
print("Group and sum up the values")
print("data5 = data4.groupby(data4.index).sum()")
data5 = data4.groupby(data4.index).sum()
# Get rid of the unnecessary datarow
print()
print("Get rid of unnecessary datarow and filter down to only the United States")
print("data6 = data5.drop(['Recovered', 'Diamond Princess', 'Grand Princess', 'Guam', 'Northern Mariana Islands', 'Puerto Rico', 'Virgin Islands']")
data6 = data5.drop(["Recovered", "Diamond Princess", "Grand Princess", "Guam", "Northern Mariana Islands", "Puerto Rico", "Virgin Islands"])

print(f'\n ------ Print the new data6 Information ------')
print()
print( data6 )

# Start statistical analysis on the states
print(f"\n Statistical analysis on the states")
print( data6.describe())
print()


print( "Total Number of confirmed cases in the United States:", sum(data6["Confirmed"]) )
print()
print( "Total Number of deaths in the United States:", sum(data6["Deaths"]) )
print()

print("State with most confirmed cases:")
print( data6.loc[data6['Confirmed'].idxmax()])
print()
print("State with most confirmed deaths:")
print( data6.loc[data6['Deaths'].idxmax()])
print()

print( "State with least confirmed cases:")
print( data6.loc[data6['Confirmed'].idxmin()])
print()
print( "State with least confirmed deaths:")
print( data6.loc[data6['Deaths'].idxmin()])
print()


print( "NOTE: Plots can be viewed by running the program or the attached image files" )
# Plots
# - Boxplot -------------------------------------------------------------------
print("Boxplot")
data6.boxplot()
plt.title('05/01/2020 COVID-19 Confirmed Cases vs Deaths')
plt.ylabel('Number of Observations')
plt.show()

# - Histogram with 2 different bin sizes --------------------------------------
print("Histogram")
data6.plot.hist(bins=100)
plt.title('05/01/2020 COVID-19 Confirmed Cases vs Deaths')
plt.xlabel('Number of Observations')
plt.ylabel('Number of States')
plt.show()

# - Regression Line with Data Scatter -----------------------------------------
slope, intercept, r_value, p_value, std_err = stats.linregress( data6 )
print("Scatterplot with Regression Line")
data6.plot.scatter( x = 'Confirmed', y = 'Deaths' )
plt.plot( data6, intercept + slope*data6, 'red', label='fitted line')
plt.title('05/01/2020 COVID-19 Confirmed Cases vs Deaths')
plt.xlabel('Confirmed Cases')
plt.ylabel('Number of Deaths')
plt.show()

# - Vertical Bar Graph ----------------------------------------
print("Bar Graph")
data6.plot.bar()
plt.title('05/01/2020 COVID-19 Confirmed Cases vs Deaths by State')
plt.xlabel('State')
plt.ylabel('Number of Observations')
plt.show()
print()

print(" CONCLUSION: ")
print( "From the analysis performed, New York State seems to have the highest number of reported cases and deaths."
      " While Alaska has the lowest number of reported cases and Wyoming has the lowest number of deaths. Alaska"
      " could have data gathering issues such as not having proper testing which leads inaccurate data. Since this is northwest of the mainland US,"
      " there could simply be less people traveling to and from which also reduces the number of cases and deaths. Wyoming, on the otherhand, is part"
      " of the mainland US and still has the lowest number of deaths in the country. There could also be inaccurate data reporting and gathering"
      " going on here as well." )
print()
print( "This analysis provides general information on the COVID-19 pandemic plagueing our world, however, with data such as this"
      " proper health and safety measures can be taken into place. There could be further analysis done on this dataset such as"
      " finding the data for each individual city in the United States, but that would addfurther complexity to the analysis being performed"
      " which would likely increase CPU time.")
print('\n --------------------------- END OF PROGRAM -----------------')


