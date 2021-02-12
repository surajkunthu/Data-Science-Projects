###################################
# Suraj Kunthu
###################################

# Two regional bus lines are interested in the timeliness of their buses 
# during the late afternoon rush between 3:30pm and 5:30pm.  To understand the 
# timeliness they randomly sample bus lines and for Richmond (denoted with an R) and Norfolk 
# (denoted with an N).  The data is the Bus1.txt data attached.

# Read in the Bus1.txt data
bus1 <- read.table( file.choose(), header = TRUE )

# Create a column to match dataframe with proper city denotations to make data filtering simple
city <- c( "R", "R", "R", "R", "R", "R", "R", "R", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N" )

# Bind the city column to dataframe
bus1 <- cbind( city, bus1 )

## Question 01 #########################################################################################################
# 1. It is acceptable for a bus to be late up to 5 minutes in Richmond and up to 7 minutes in Norfolk.  
# Test to see if the mean delay is within the acceptable time using:
#      a.  T-test
#      b.  Wilcoxon Rank-Sum test.

# Subset the data for Richmond line buses and Norfolk lines buses
richbus <- bus1$Late[ bus1$city == "R" ]
norbus <- bus1$Late[ bus1$city == "N" ]

# To conduct the test, first create a container matrix to compare the values of the t.test and wilcox.test
comparison1 <- matrix( 0, nrow = 2, ncol = 2 )

# Add row names for the city
row.names( comparison1 ) <- c( "Richmond", "Norfolk" )

# Change the column headers
colnames( comparison1 ) <- c( "t.test", "wilcox.test" )

# Conduct test for Richmond Bus lines
t.test( richbus, mu = 5, conf.level = 0.9 )
wilcox.test( richbus, mu = 5, conf.level = 0.9 )

# Store the p-value into comparison table
comparison1[ 1, 1 ] <- t.test( richbus, mu = 5, conf.level = 0.9  )$p.value
comparison1[ 2, 1 ] <- wilcox.test( richbus, mu = 5, conf.level = 0.9 )$p.value

# Conduct test for Norfolk Bus lines
t.test( norbus, mu = 7, conf.level = 0.9 )
wilcox.test( norbus, mu = 7, conf.level = 0.9 )

# Store the p-value into comparison table
comparison1[ 1, 2 ] <- t.test( norbus, mu = 7, conf.level = 0.9 )$p.value
comparison1[ 2, 2 ] <- wilcox.test( norbus, mu = 7, conf.level = 0.9 )$p.value

# Check values
head( comparison1 )

# One Sample Test for Richmond Bus
# Null Hypothesis (H_0): mu_richmond = 5
# Alternative Hypothesis (H_A): mu_richmond != 5
# Significance Level (alpha) = 0.1
# t.test: p-value = 0.9906497
# wilcox.test: p-value = 0.5468750
# Decision Rule: If p-value < alpha, reject H0 in favor of HA.
# Conclusion:
# In both tests, p-value is greater than alpha. We fail to reject the null hypothesis. So we cannot clearly say whether mu is 5 or not.

# One Sample Test for Norfolk Bus Lines
# Null Hypothesis (H_0): mu_norfolk = 7
# Alternative Hypothesis (H_A): mu_norfolk != 7
# Significance Level (alpha) = 0.1
# t.test: p-value = 0.516483
# wilcox.test: p-value = 1.000000
# Decision Rule: If p-value < alpha, reject H0 in favor of HA.
# Conclusion:
# In both tests, p-value is greater than alpha. We fail to reject the null hypothesis. So we cannot clearly say whether mu is 7 or not.

# Based on these tests performed, it seems that the t-test is better to use here than the wilcoxon rank-sum test. In the Richmond subset of data, the mean value
# found from the t.test was 4.975 which is very close to the test mean of 5. Although we cannot statistically prove they are the same we can observe
# as a outsider that the mean is very close. In the Norfolk subset of data, the wilcoxon test output a p-value of 1 which tells us there is weak evidence
# against the null hypothesis. So we take the t-test p-value.

## Question 02 #########################################################################################################
# 2.  Test to see if the two cities bus lines have the same delay using:
#      a. Two sample T-test (Check all Assumptions)
#      b. Wilcoxon Rank Sum Test
#      c. Randomization test.

# To conduct the test, first create a container to compare the values of the t.test, wilcox.test, and randomization test
comparison2 <- matrix( 0, nrow = 1, ncol = 3 )

# Change the column headers
colnames( comparison2 ) <- c( "t.test", "wilcox.test", "Randomization test")


# Subset data to find the buses that run on the same lines
samelines <- bus1[ c(1:3, 7:9, 11:13, 17 ), ]

# Conduct the Two-Sample T-Test and Wilcoxon Rank Sum test
comparison2[ 1, 1 ] <- t.test( samelines$Late[samelines$city == "R"], samelines$Late[samelines$city == "N"], conf.level = 0.9 )$p.value
comparison2[ 1, 2 ] <- wilcox.test( samelines$Late[samelines$city == "R"], samelines$Late[samelines$city == "N"], conf.level = 0.9 )$p.value

# Find the mean of the subsetted data that is unscrambled
unscrambledmean <- mean( samelines$Late[samelines$city == "R"] ) - mean( samelines$Late[samelines$city == "N"] )

# Subset the data further to two specific columns
samelinessubset <- samelines[ -c(2:3) ]

# Conduct the Randomization Test
# Scramble the labels
scrambleout1 <- rep( 0, 1000 )
for( i in 1:1000 ){
  scrambled <- sample( samelinessubset$city, 
                       length( samelinessubset$city ), 
                       replace = FALSE )
  scrambleout1[ i ] <- mean( samelinessubset$Late[ scrambled == "R" ] ) - mean( samelinessubset$Late[ scrambled == "N" ] )
}

# Check histogram to visually see where the mean is
# hist( scrambleout1 )
# abline( v = unscrambledmean, col = "red" )

# To find p-value from 1000-times scrambled data
comparison2[ 1, 3 ] <- mean( ifelse( scrambleout1 < unscrambledmean, 1, 0 ) )

# Check values
head( comparison2 )

# Two-Sample T-Test and Wilcoxon Rank-Sum test
# Null Hypothesis (H_0): mu_richmond = mu_norfolk
# Alternative Hypothesis (H_A): mu_richmond != mu_norfolk
# Significance Level (alpha) = 0.1
# t.test: p-value = 0.332
# wilcox.test: p-value = 0.421
# Randomization Test (value will vary): p-value = 0.153
# Decision Rule: If p-value < alpha, reject H0 in favor of HA.

# Randomization Test
# Null Hypothesis (H_0): The labels don't matter
# Alternative Hypothesis (H_A): The label's matter
# Significance Level (alpha) = 0.1
# t.test: p-value = 0.332
# wilcox.test: p-value = 0.421
# Randomization Test (value will vary): p-value = 0.153
# Decision Rule: If p-value < alpha, reject H0 in favor of HA.

# Conclusion:
# In all the tests, the p-value is greater than alpha. We fail to reject the null hypothesis. So we cannot clearly say whether the mu's are equal or 
# if the labels do not matter. However, the randomization test's p-value is closest (through 1000 scrambles) to the significance level. 
# This suggests that the randomization test proves to be the best test to use in a situation such as this, so I would
# recommend the randomization test over the Two-Sample t-test and the Wilcoxon Rank-Sum test.

## Question 03 #########################################################################################################
# 3.  Create power curves for detecting difference from 0 to 20 minutes using simulation for the following tests.
#      a. Two sample T-test
#      b. Wilcoxon Rank Sum Test
#      c. Randomization test.

# Create a function for the randomization test to give us a p-value
randtest1 <- function( X1, group1 ){
  out1 <- rep( 0, 1000 )
  for( i in 1:1000 ){
    stat2 <- sample( group1, 
                     length( group1 ), 
                     replace = FALSE )
    out1[ i ] <- mean( X1[ stat2 == "R" ] ) - mean( X1[ stat2 == "N" ] )
  }
  
  diff1 <- mean( X1[ group1 == "R" ] ) - mean( X1[ group1 == "N" ] )
  
  # To find p-value from 1000-times scrambled data
  res1 <- mean( ifelse( out1 > diff1 , 1, 0 ) )
  return( res1 )
}

# Values for 0 to 20 minutes using simulation
mu1 <- seq( 0, 20, by = 0.1)
# Create a container for each test
pow1t <- rep( 0, length( mu1 ) )
pow1w <- rep( 0, length( mu1 ) )
pow1r <- rep( 0, length( mu1 ) )
for( j in 1:length( mu1 ) ){
  # Containers for results
  print( j )
  tout1 <- rep( 0, 1000 )
  wout1 <- rep( 0, 1000 )
  rout1 <- rep( 0, 1000 )
  for( i in 1:1000 ){
    # Generate data at the null hypothesis
    x2 <- c( rnorm( 18, mu1[ j ], 1 ),      # group that is not changing
             rnorm( 18, 0, 1 ) )            # group that is changing
    g2 <- c( rep( "R", 18 ), rep( "N", 18 ) )
    # Run the tests
    tout1[ i ] <- t.test( x2 ~ g2 )$p.value    # ~ x2 testing against g2
    wout1[ i ] <- wilcox.test( x2 ~ g2 )$p.value
    rout1[ i ] <- randtest1( x2, g2 )          # comma here because it is calling out function
  }
  pow1t[ j ] <- mean( ifelse( tout1 < 0.01, 1, 0 ) )
  pow1w[ j ] <- mean( ifelse( wout1 < 0.01, 1, 0 ) )
  pow1r[ j ] <- mean( ifelse( rout1 < 0.01, 1, 0 ) )
}

plot( mu1, pow1t, type = "l", col = "cyan",
      main = "Test of Power",
      ylab = "Power",
      xlab = "Mu")
lines( mu1, pow1w, col = "magenta" )
lines( mu1, pow1r, col = "seagreen" )
abline( 0.8, 0, col = "orange", lty = 2 )
legend( 5, 0.6,
        c( " T-test", "Wilcoxon Rank-Sum Test", "Randomization Test"),
        col = c( "cyan", "magenta", "seagreen"),
        pch = c( 1 ,1, 1 ) )

output1 <- data.frame( mu = mu1, 
                       power.t = pow1t,
                       power.w = pow1w,
                       power.r = pow1r )

# For majority of the simulation, the randomization test is more powerful. This can be seen in the figure, Figure 1, below.
# This shows that the labels of a dataset do not matter when determining the difference.
  