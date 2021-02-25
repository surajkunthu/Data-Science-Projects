###################################
# Probability Distributions
###################################

# Question 01 ###################################
# 1. Generate 10,000 deviates from the standard normal distribution using k-uniform random deviates 
# where k is 2, 4, 6, 8, 10 and plot each of these on the same QQPlot each with different colors. 

# Create a Function to Generate Normal Distribution
NormalDist<- function( k ){        # k is the number of uniforms
  numDeviate <- 10000              # Number of Deviates
  res1 <- rep( 0, numDeviate )     # container to hold the answer
  for( i in 1:k ){
    res1 <- res1 + runif( numDeviate, 0 , 1 )
  }
  res1 <- res1 - k/2               # centered at zero
  return( res1 )
}

# Standard normal distribution using k-uniform random deviates 
Question1_1 <- NormalDist( k = 2 )
Question1_2 <- NormalDist( k = 4 )
Question1_3 <- NormalDist( k = 6 )
Question1_4 <- NormalDist( k = 8 )
Question1_5 <- NormalDist( k = 10 )

# Percentiles that match the number of samples
pct1 <- ( 1:10000 ) / 10000
# To create a PDF of the Plot

# Plot of k = 2
plot( sort( Question1_1 ),                               # Theoretical Quantiles
      qnorm( pct1 ),                                      # Sample Quantiles
      col = "blue",
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "Normal Q-Q Plot for k-uniform random deviates",
      sub = "Standard Normal Distribution" )
# Adding on k = 4
points( sort( Question1_2 ),
        qnorm( pct1 ), 
        col = "yellow" )
# Adding on k = 6
points( sort( Question1_3 ), 
        qnorm( pct1 ), 
        col = "red" )
# Adding on k = 8
points( sort( Question1_4 ), 
        qnorm( pct1 ), 
        col = "purple" )
# Adding on k = 10
points( sort( Question1_5 ), 
        qnorm( pct1 ), 
        col = "green" )
abline( 0, 1, col = "black", lty = 3 )  #45-degree angle line

legend( -0.75, 3.75,
        c( "k = 2", "k = 4", "k = 6", "k = 8", "k = 10"),
        col = c( "blue", "yellow", "red", "purple", "green" ),
        pch = c( 1 ,1, 1, 1, 1) )

# Question 02 ###################################
# 2.  Generate 10,000 deviates from the Chi-Square distribution with df = 1 using 
# k-uniform random deviates where k is 2, 4, 6, 8, 10 and plot each of these on the same QQPlot 
# each with different colors.

# Create a Function to Generate Chi-Square Distribution
ChiSquare <- function( df, k ){
  # df is the degrees of freedom
  # k is the number of uniforms I want to add together
  numDeviate <- 10000               # Number of Deviates
  res1 <- rep( 0, numDeviate )      # container to hold answer
  for( i in 1:df ){
    res1 <- res1 + NormalDist( k )^2
  }
  return( res1 )
}

# Chi-Square_1 distribution using k-uniform random deviates 
Question2_1 <- ChiSquare( df = 1, k = 2 )
Question2_2 <- ChiSquare( df = 1, k = 4 )
Question2_3 <- ChiSquare( df = 1, k = 6 )
Question2_4 <- ChiSquare( df = 1, k = 8 )
Question2_5 <- ChiSquare( df = 1, k = 10 )

# Percentiles...needs to match the number of samples
pct1 <- ( 1:10000 ) / 10000
# To create a PDF

# Plot of k = 2
plot( sort( Question2_1 ),                                # Theoretical Quantiles
      qchisq( pct1, df = 1 ),                             # Sample Quantiles
      col = "blue",
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "Chi-Square Q-Q Plot for k-uniform random deviates with df = 1",
      sub = "Chi-Square_1 Distribution")
# Adding on k = 4
points( sort( Question2_2 ),
        qchisq( pct1, df = 1 ), 
        col = "yellow" )
# Adding on k = 6
points( sort( Question2_3 ), 
        qchisq( pct1, df = 1 ), 
        col = "red" )
# Adding on k = 8
points( sort( Question2_4 ), 
        qchisq( pct1, df = 1 ), 
        col = "purple" )
# Adding on k = 10
points( sort( Question2_5 ), 
        qchisq( pct1, df = 1 ), 
        col = "green" )
abline( 0, 1, col = "black", lty = 3 ) #45-degree angle line

legend( 0, 14,
        c( "k = 2", "k = 4", "k = 6", "k = 8", "k = 10"),
        col = c( "blue", "yellow", "red", "purple", "green" ),
        pch = c( 1 ,1, 1, 1, 1) )

# Question 03 ###################################
# 3.  Generate 10,000 deviatexs from the Chi-square distribution with df = 10 using k-uniform random 
# deviates (for each of the Chi-Square_1 deviates) where k is 2, 4, 6, 8, 10 and plot these on the 
# same QQPlot each with different colors.

# Chi-Square_10 distribution using k-uniform random deviates 
Question3_1 <- ChiSquare( df = 10, k = 2 )
Question3_2 <- ChiSquare( df = 10, k = 4 )
Question3_3 <- ChiSquare( df = 10, k = 6 )
Question3_4 <- ChiSquare( df = 10, k = 8 )
Question3_5 <- ChiSquare( df = 10, k = 10 )

# Percentiles...needs to match the number of samples
pct1 <- ( 1:10000 ) / 10000
# To create a PDF

# Plot of k = 2
plot( sort( Question3_1 ),                                # Theoretical Quantiles
      qchisq( pct1, df = 10 ),                             # Sample Quantiles
      col = "blue",
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "Chi-Square Q-Q Plot for k-uniform random deviates with df = 10",
      sub = "Chi-Square_10 Distribution")

# Adding on k = 4
points( sort( Question3_2 ),
        qchisq( pct1, df = 10 ), 
        col = "yellow" )
# Adding on k = 6
points( sort( Question3_3 ), 
        qchisq( pct1, df = 10 ), 
        col = "red" )
# Adding on k = 8
points( sort( Question3_4 ), 
        qchisq( pct1, df = 10 ), 
        col = "purple" )
# Adding on k = 10
points( sort( Question3_5 ), 
        qchisq( pct1, df = 10 ), 
        col = "green" )
abline( 0, 1, col = "black", lty = 3 ) # 45-degree angle line
legend( 1.0, 30,
        c( "k = 2", "k = 4", "k = 6", "k = 8", "k = 10"),
        col = c( "blue", "yellow", "red", "purple", "green" ),
        pch = c( 1 ,1, 1, 1, 1) )

# Question 04 ###################################
# 4.  Generate 10,000 deviates from the Exponential distribution with beta = 2 using the 
# inverse cdf method and plot these on a QQplot.

# Uniform distribution of 10,000 deviates
U1 <- runif( 10000, 0, 1 )
# Exponential(2)
beta1 <- 2
# Exponential Distribution Formula Inverse CDF Method
E1 <- -log( 1 - U1 ) / beta1
# Percentiles to match the number of samples
pct2 <- seq( 0, 1, length.out = 10000 )

plot( sort( E1 ),
      qexp( pct2, 2 ),
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "Exponential Q-Q Plot using Inverse CDF method with Beta = 2",
      sub = "Exponential Distribution")
abline( 0, 1, col = "red", lty = 3)

# Question 05 ###################################
# 5.  Generate 10,000 deviates from the Gamma(5,2) distribution using the sum of 
# exponentials method and plot these on a QQplot.  On a separate plot overlay the 
# samples you obtained in #3 where k = 10

# Uniform distribution of 10,000 deviates
U1 <- runif( 10000, 0, 1 )
# Gamma( 5, 2 )
alpha1 <- 5
beta2 <- 2
# Create a function to generate the Gamma Distribution
GammaDist <- function( alpha1, beta2 ){
  numDeviate <- 10000                  # Number of Deviates
  res1 <- res1 <- rep( 0, numDeviate ) # container to hold answer
  for( i in 1:alpha1 ){
    res1 <- res1 + ( -log( 1 - U1 ) / beta2 )
  }
  return(res1)
}

# Gamma(5,2) distribution
Question5 <- GammaDist( alpha1, beta2 )
# Percentiles to match the number of samples
pct2 <- seq( 0, 1, length.out = 10000 )

plot( sort( Question5 ),
      qgamma( pct2, alpha1, beta2 ),
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "Gamma(5,2) Q-Q Plot using sum of exponentials method",
      sub = "Gamma Distribution" ) 


qqplot( sort( Question5 ), 
        sort( Question3_5 ), 
        col = c("blue", "red"),
        ylab = "Sample Quantiles",
        xlab = "Theoretical Quantitles",
        main = "Q-Q Plot Comparison between Gamma and Chi-Square Dist." ) 

legend( 4, 10,
        c( "Gamma(5,2)", "Chi-Square_10 with df = 10 and k = 10"),
        col = c( "blue", "red"),
        pch = c( 1, 1 ) )

# Question 06 ###################################
# 6.  Generate 10,000 deviates from a T distribution with 5 degrees of freedom using the 
# samples you obtained in #1 and #3 for k = 2, 4, 6, 8, 10 and plot these on the same 

# Create a function to generate the T-distribution
Tdist <- function ( df, k ){
  numDeviates <- 10000
  res1 <- rep( 0, numDeviates ) # container to hold the answer
  for( i in 1:df ){
    res1 <- res1 +  ( NormalDist( k ) / ( ( ChiSquare( df, k ) / df )^0.5 ) )
  }
  return( res1 )
}

# T distribution with k deviates
Question6_1 <- Tdist( df = 5, k = 2 )
Question6_2 <- Tdist( df = 5, k = 4 )
Question6_3 <- Tdist( df = 5, k = 6 )
Question6_4 <- Tdist( df = 5, k = 8 )
Question6_5 <- Tdist( df = 5, k = 10 )

# Percentiles to match the number of samples
pct2 <- seq( 0, 1, length.out = 10000 )


# Plot of k = 2
plot( sort( Question6_1 ),                            # Theoretical Quantiles
      qt( pct2, df = 5 ),                             # Sample Quantiles
      col = "blue",
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "T-Dist. Q-Q Plot for k-uniform random deviates with df = 5" )
# Adding on k = 4
points( sort( Question6_2 ),
        qt( pct2, df = 5 ), 
        col = "yellow" )
# Adding on k = 6
points( sort( Question6_3 ), 
        qt( pct2, df = 5 ), 
        col = "red" )
# Adding on k = 8
points( sort( Question6_4 ), 
        qt( pct2, df = 5 ), 
        col = "purple" )
# Adding on k = 10
points( sort( Question6_5 ), 
        qt( pct2, df = 5 ), 
        col = "green" )

legend( -12, 8,
        c( "k = 2", "k = 4", "k = 6", "k = 8", "k = 10"),
        col = c( "blue", "yellow", "red", "purple", "green" ),
        pch = c( 1 ,1, 1, 1, 1) )

# Question 07 ###################################
# 7.  Generate 10,000 deviates from an F(1,5) distribution using the samples from #6 for k = 2, 4, 6, 8, 10 
# and plot these on the same QQplot with different colors corresponding to the different values of k.  

# Function to generate the F-distribution
Fdist <- function( d1, d2, k ){
  numDeviates <- 10000              # Number of Deviates
  res1 <- rep( 0, numDeviates )     # container to hold numerator
  res2 <- rep( 0, numDeviates )     # container to hold denominator
  res3 <- rep( 0, numDeviates )
  for( i in 1:d1){
    res1 <- ( ChiSquare( d1, k ) / d1 )   # Numerator
    res1 <- res1 + res1
  }
  for( i in 1:d2){
    res2 <- ( ChiSquare( d2, k ) / d2)    # Denominator
    res2 <- res2 + res2
  res3 <- res1/res2
  return( res3 )
  }
}

# F(1,5) distribution with k-number deviates
Question7_1 <- Fdist( 1, 5, 2 )
Question7_2 <- Fdist( 1, 5, 4 )
Question7_3 <- Fdist( 1, 5, 6 )
Question7_4 <- Fdist( 1, 5, 8 )
Question7_5 <- Fdist( 1, 5, 10 )

# Create a qqplot
pct2 <- seq( 0, 1, length.out = 10000 )

# Plot of k = 2
plot( sort( Question7_1 ),                            
      qf( pct2, 1, 5 ),            
      col = "blue",
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "F(1,5) Dist. Q-Q Plot for k-number random deviates" )
# Adding on k = 4
points( sort( Question7_2 ),
        qf( pct2, 1, 5 ), 
        col = "yellow" )
# Adding on k = 6
points( sort( Question7_3 ), 
        qf( pct2, 1, 5 ), 
        col = "red" )
# Adding on k = 8
points( sort( Question7_4 ), 
        qf( pct2, 1, 5 ), 
        col = "purple" )
# Adding on k = 10
points( sort( Question7_5 ), 
        qf( pct2, 1, 5 ), 
        col = "green" )
abline( 0, 1, col = "black", lty = 3 )

legend( 100, 40,
        c( "k = 2", "k = 4", "k = 6", "k = 8", "k = 10"),
        col = c( "blue", "yellow", "red", "purple", "green" ),
        pch = c( 1 ,1, 1, 1, 1) )

# Question 08 ###################################
# 8.  Use what you have learned to generate 10,000 deviates from an F(5,15) only using uniform 
# random deviates for k = 2, 4, 6, 8 and 10.  Plot these on a QQplot with different colors 
# corresponding to the different values of k.

# F(5,15) distribution with k-number deviates 
Question8_1 <- Fdist( 5, 15, 2 )
Question8_2 <- Fdist( 5, 15, 4 )
Question8_3 <- Fdist( 5, 15, 6 )
Question8_4 <- Fdist( 5, 15, 8 )
Question8_5 <- Fdist( 5, 15, 10 )

# Create a qqplot
pct2 <- seq( 0, 1, length.out = 10000 )

# Plot of k = 2
plot( sort( Question8_1 ),                            
      qf( pct2, 5, 15 ),            
      col = "blue",
      ylab = "Sample Quantiles",
      xlab = "Theoretical Quantitles",
      main = "F(5,15) Dist. Q-Q Plot for k-uniform random deviates" )
# Adding on k = 4
points( sort( Question8_2 ),
        qf( pct2, 5, 15 ), 
        col = "yellow" )
# Adding on k = 6
points( sort( Question8_3 ), 
        qf( pct2, 5, 15 ), 
        col = "red" )
# Adding on k = 8
points( sort( Question8_4 ), 
        qf( pct2, 5, 15 ), 
        col = "purple" )
# Adding on k = 10
points( sort( Question8_5 ), 
        qf( pct2, 5, 15 ), 
        col = "green" )
abline( 0, 1, col = "black", lty = 3 )   # 45-degree angle line

legend( 0, 10,
        c( "k = 2", "k = 4", "k = 6", "k = 8", "k = 10"),
        col = c( "blue", "yellow", "red", "purple", "green" ),
        pch = c( 1 ,1, 1, 1, 1) )

