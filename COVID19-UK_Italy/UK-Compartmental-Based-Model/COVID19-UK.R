######################################
# Suraj Kunthu
######################################

# Goal 1: =======================================================================================
# Fit a compartmental model to the best of your ability for the country you have 
# been assigned.  Explain how you arrived at the model you chose.  Then compare it to the
# data available up until the presentation.

# Read in the GlobalCovid19-2020-04-08.csv
# Cdata1 <- read.csv( file.choose(), head = TRUE )
# head( Cdata1 ) # check to see what the data looks like

# Subset the United Kingdom data from Cdata1
uk1 <- Cdata1[ Cdata1$Country == "United Kingdom", ]

# Adjust Infected to remove recovered and remove deaths
uk1$AdjInfect <- uk1$Confirmed - uk1$Recovered - uk1$Deaths
# head( uk1 ) # check to see what the data looks like

# Subset the mainland United Kingdom data from uk1
ukmainland1 <- uk1[ uk1$Prov.State== "", ] 

head( ukmainland1 ) # check to see what the data looks like

# pdf("~/Documents/My Documents/Ukplot1.pdf")
plot( ukmainland1$Date, ukmainland1$Confirmed,
      main = "Confirmed Cases in Mainland UK", 
      xlab = "Date")
points( ukmainland1$Date, ukmainland1$Recovered,
        col = "seagreen" )
points( ukmainland1$Date, ukmainland1$Deaths,
        col = "red" )
legend( 0, 30000,
        c( "Confirmed", "Recovered", "Deaths" ),
        col = c( "black", "seagreen", "red" ),
        pch = c( 1, 1, 1, 1 ) )
# dev.off()
# Building the Model -----------------

# Simple model (SEIRD Model)
# S0 <- # number of people susceptible
# E0 <- # number of people exposed
# I0 <- # number of people infected (tested positive for virus)
# R0 <- # number of people recovered 
# D0 <- # number of people who died from the disease
S0 <- 67805347     # UK population
# S0 <- 67811249 # number obtained from https://www.worldometers.info/world-population/uk-population/
E0 <- 2        # Intial Exposed
I0 <- 0        # Initial Infected
R0 <- 0        # Initial Recovered
D0 <- 0        # Initial Deaths

# Parameter Value
alpha1 <- 1/100000000           # Are Susceptible
alpha2 <- -1/100000000          # intervention1
alpha3 <- -1/100000000          # intervention2
alpha4 <- -1/100000000          # intervention3
beta1 <- 1/7                    # Exposed -> Infected
gamma1 <- 1/7                   # Exposed -> Recovered
eta1 <- 1/1000                  # Exposed -> Death

# Knots, or points where intervention took place
chpt1 <- 58        # Time at which we believe intervention took place (quarantine etc)
chpt2 <- 65
chpt3 <- 74

n1 <- nrow( ukmainland1 )


SEIRD1 <- function( S0, E0, I0, R0, D0,
                    alpha1, alpha2, alpha3, alpha4, 
                    beta1, gamma1, eta1, n1, chpt1, chpt2, chpt3 ){
  
  Out1 <- data.frame( S = rep( S0, n1 ),
                      E = rep( E0, n1 ),
                      I = rep( I0, n1 ),
                      R = rep( R0, n1 ),
                      D = rep( D0, n1 ) )
  for( i in 2:n1 ){
    S0n <- S0
    E0n <- E0
    I0n <- I0
    R0n <- R0
    D0n <- D0
    intervention1 <- ifelse( i < chpt1, 0, 1 )
    intervention2 <- ifelse( i < chpt2, 0, 1 )
    intervention3 <- ifelse( i < chpt3, 0, 1 )
    S0 <- max( 0, S0n - ( alpha1 + alpha2*intervention1 - alpha3*intervention2 + alpha4*intervention3 )*S0n*E0n )
    E0 <- max( 0, E0n + ( alpha1 + alpha2*intervention1 - alpha3*intervention2 + alpha4*intervention3 )*S0n*E0n - beta1*E0n )
    I0 <- max( 0, I0n + beta1*E0n  - gamma1*I0n - eta1*I0n )
    R0 <- R0n + gamma1*I0n
    D0 <- D0n + eta1*I0n
    Out1[ i, ] <- c( S0, E0, I0, R0, D0 )
  }
  return( Out1 )
}

Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                alpha1, alpha2, alpha3, alpha4, 
                beta1, gamma1, eta1, n1, chpt1, chpt2, chpt3 )

# Make a Plot of the Model
plot( 1:n1, Out1$S, 
      type = "l", 
      col = "purple" ,
      main = "Plot of the Model",
      ylab = "Number of People",
      xlab = "Number of Observations" )
lines( 1:n1, Out1$E, col = "orange" )
lines( 1:n1, Out1$I, col = "red" )
lines( 1:n1, Out1$R, col = "seagreen" )
lines( 1:n1, Out1$D, col = "black" )
abline( 0, 0, lty = 3, col = "gray" )

# Testing values  -----------------
# S0 <- # number of people susceptible
# E0 <- # number of people exposed
# I0 <- # number of people infected (tested positive for virus)
# R0 <- # number of people recovered 
# D0 <- # number of people who died from the disease
S0 <- 67805347     # UK population
# S0 <- 67886011 # Population of United Kingdom
E0 <- 2 # latent (unobserved) variable
I0 <- 2
R0 <- 0
D0 <- 0

# Parameter Value
alpha1 <- 1/225000000    # Are Susceptible
alpha2 <- -1/800000000   # intervention1
alpha3 <- -1/800000000   # intervention2
alpha4 <- -1/800000000   # intervention3
beta1 <- 1/7             # Exposed -> Infected
gamma1 <- 1/20           # Exposed -> Recovered
eta1 <- 1/35             # Exposed -> Death

Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                alpha1, alpha2, alpha3, alpha4, 
                beta1, gamma1, eta1, n1, chpt1, chpt2, chpt3 )

# Error Function
Err1 <- function( S0, E0, I0, R0, D0,
                  alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                  chpt1, chpt2, chpt3,
                  ukmainland1 ){
  Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                  alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                  chpt1, chpt2, chpt3 ) 
  sum1 <- sum( ( ukmainland1$AdjInfect - Out1$I )^2 )
  sum2 <- sum( ( ukmainland1$Recovered - Out1$R )^2 )
  sum3 <- sum( ( ukmainland1$Deaths - Out1$D )^2 )
  sum4 <- sum1 + sum2 + sum3
  return( sum4 )
}

Err1( S0, E0, I0, R0, D0,
      alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
      chpt1, chpt2, chpt3,
      ukmainland1 )

# Goal is to minimize the error
#  f'(x) = lim ( f(x+h) - f(x) )/h
ErrSign1 <- function( S0, E0, I0, R0, D0,
                      alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                      chpt1, chpt2, chpt3,
                      ukmainland1 ){
  Err0 <- Err1( S0, E0, I0, R0, D0,
                alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                chpt1, chpt2, chpt3,
                ukmainland1 )
  alpha1prime <- ( Err1( S0, E0, I0, R0, D0,
                        alpha1 + 1/175000000000, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                        chpt1, chpt2, chpt3,
                        ukmainland1 ) - Err0 )/( 1/175000000000 )
  alpha2prime <- ( Err1( S0, E0, I0, R0, D0,
                        alpha1, alpha2 + 1/175000000000, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                        chpt1, chpt2, chpt3,
                        ukmainland1 ) - Err0 )/( 1/175000000000 )
  alpha3prime <- ( Err1( S0, E0, I0, R0, D0,
                        alpha1, alpha2, alpha3 + 1/175000000000, alpha4, beta1, gamma1, eta1, n1, 
                        chpt1, chpt2, chpt3,
                        ukmainland1 ) - Err0 )/( 1/175000000000 )
  alpha4prime <- ( Err1( S0, E0, I0, R0, D0,
                        alpha1, alpha2, alpha3, alpha4 + 1/175000000000, beta1, gamma1, eta1, n1, 
                        chpt1, chpt2, chpt3,
                        ukmainland1 ) - Err0 )/ (1/175000000000 )
  beta1prime <- ( Err1( S0, E0, I0, R0, D0,
                       alpha1, alpha2, alpha3, alpha4, beta1 + 1/700, gamma1, eta1, n1, 
                       chpt1, chpt2, chpt3,
                       ukmainland1 ) - Err0 )/( 1/700 )
  eta1prime <- ( Err1( S0, E0, I0, R0, D0,
                      alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1 + 1/3500, n1, 
                      chpt1, chpt2, chpt3,
                      ukmainland1 ) - Err0 )/( 1/3500 )
  gamma1prime <- ( Err1( S0, E0, I0, R0, D0,
                        alpha1, alpha2, alpha3, alpha4, beta1, gamma1 + 1/2000, eta1 , n1, 
                        chpt1, chpt2, chpt3,
                        ukmainland1 ) - Err0 )/( 1/2000 )
  Res1 <- sign( c( alpha1prime,
                   alpha2prime,
                   alpha3prime,
                   alpha4prime,
                   beta1prime,
                   gamma1prime,
                   eta1prime
  ) )
  return( Res1 )
}


StepSize1 <- c( 1/1000000000000000,     # step size for alpha1
                1/1000000000000000,     # step size for alpha2
                1/1000000000000000,     # step size for alpha3
                1/1000000000000000,     # step size for alpha4
                1/1000,                 # ... beta1
                1/2000,                 # ... gamma1
                1/5000 )                 # ... eta1

# Update the Parameters -------------
# Update the parameters, this code will figure out which way to go to get smaller and make it happen
# Run this to update the parameters to minimize the squared loss

for( i in 1:100 ){
  StepSign1 <- ErrSign1( S0, E0, I0, R0, D0,
                        alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                        chpt1, chpt2, chpt3,
                        ukmainland1 ) 
  alpha1 <- alpha1 - StepSize1[ 1 ]*StepSign1[ 1 ]
  alpha2 <- alpha2 - StepSize1[ 2 ]*StepSign1[ 2 ]
  alpha3 <- alpha3 - StepSize1[ 3 ]*StepSign1[ 3 ]
  alpha4 <- alpha4 - StepSize1[ 4 ]*StepSign1[ 4 ]
  beta1 <- beta1 - StepSize1[ 5 ]*StepSign1[ 5 ]
  gamma1 <- gamma1 - StepSize1[ 6 ]*StepSign1[ 6 ]
  eta1 <- eta1 - StepSize1[ 7 ]*StepSign1[ 7 ]
  
  Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                  alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1, 
                  chpt1, chpt2, chpt3 )
}

# Simple Plots ------------
par( mfrow = c( 1, 3 ) )
# Recovered
plot( 1:n1, ukmainland1$Recovered, col = "seagreen", main = "UK Recovered", xlab = "Number of Days" )
lines( 1:n1, Out1$R, col = "seagreen" )

# Infected
plot( 1:n1, ukmainland1$AdjInfect, col = "red", main = "UK (Adjusted) Infected", xlab = "Number of Days" )
lines( 1:n1, Out1$I, col = "red" )

# Deaths
plot( 1:n1, ukmainland1$Deaths, col = "black", main = "UK Deaths", xlab = "Number of Days" )
lines( 1:n1, Out1$D, col = "black" )

# Forecasting --------
n2 <- 300  # How long the process goes from start (180 days here)
Out2 <- SEIRD1( S0, E0, I0, R0, D0,
                alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1 = n2, 
                chpt1, chpt2, chpt3)
par( mfrow = c( 1,1 ) )
plot( 1:n1, ukmainland1$AdjInfect, col = "red",
      xlim = c( 0,n2 ),
      ylim = c( 0, max( Out2$D ) ),
      main = "Forecast of UK Compartmental Model",
      xlab = "Number of days",
      ylab = "Number of People")
lines( 1:n2, Out2$I, col = "red" )
points( 1:n1, ukmainland1$Recovered, col = "seagreen" )
lines( 1:n2, Out2$R, col = "seagreen")
points( 1:n1, ukmainland1$Deaths, col = "black" )
lines( 1:n2, Out2$D, col = "black" )

# Goal 2: =======================================================================================
# Choose a neighboring country and fit a model to that country.   
# You choose the country but it must share a common border even if by sea.  
# So example Ireland and France could be chosen as they share a border in the sea.  
# But Ireland and Austria do not.

# Neighboring Country chosen: US

# Subset the United States data from Cdata1
us1 <- Cdata1[ Cdata1$Country == "US", ]

# Adjust Infected to remove recovered and remove deaths
us1$AdjInfect <- us1$Confirmed - us1$Recovered - us1$Deaths

head( us1 )

plot( us1$Confirmed )
# pdf("~/Documents/My Documents/USplot1.pdf")
plot( us1$Date, us1$Confirmed,
      main = "Confirmed Cases in the US", 
      xlab = "Date")
points( us1$Date, us1$Recovered,
        col = "seagreen" )
points( us1$Date, us1$Deaths,
        col = "red" )
legend( 0, 300000,
        c( "Confirmed", "Recovered", "Deaths" ),
        col = c( "black", "seagreen", "red" ),
        pch = c( 1, 1, 1, 1 ) )
# dev.off()


# Building the Model ----------

S0 <- 329511071    # US population
E0 <- 3            # Initial exposed, ten days before first 2 infected cropped up, 2 seems reasonable
I0 <- 1            # Infected
R0 <- 0            # Recovered
D0 <- 0            # Deaths

# Parameter value 
alpha1 <- 1/100000000           # Parameter for infected 
beta1 <- 1/7                    # Parameter for exposed -> infected
gamma1 <- 1/7                   # Parameter for recovered
eta1 <- 1/1000                  # parameter for mortality

n1 <- nrow( us1 )
SEIRD1 <- function( S0, E0, I0, R0, D0,
                    alpha1, beta1, gamma1, eta1, n1 ){
  Out1 <- data.frame( S = rep( S0, n1 ),
                      E = rep( E0, n1 ),
                      I = rep( I0, n1 ),
                      R = rep( R0, n1 ),
                      D = rep( D0, n1 ) )
  for( i in 2:n1 ){
    S0n <- S0
    E0n <- E0
    I0n <- I0
    R0n <- R0
    D0n <- D0
    S0 <- max( 0, S0n - alpha1*S0n*E0n )
    E0 <- max( 0, E0n + alpha1*S0n*E0n - beta1*E0n )
    I0 <- max( 0, I0n + beta1*E0n - gamma1*I0n - eta1*I0n )
    R0 <- R0n + gamma1*I0n
    D0 <- D0n + eta1*I0n
    Out1[ i, ] <- c( S0, E0, I0, R0, D0 )
  }
  return( Out1 )
}

Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                alpha1, beta1, gamma1, eta1, n1 )

# Plot of initial model
plot( 1:n1, Out1$S, 
      type = "l",
      col = "purple",
      main = "Plot of the Model",
      ylab = "Number of People",
      xlab = "Number of Observations" )
lines( 1:n1, Out1$E, col = "orange" )
lines( 1:n1, Out1$I, col = "red " )
lines( 1:n1, Out1$R, col = "seagreen" )
lines( 1:n1, Out1$D, col = "black" )

# Testing values ----------

S0 <- 67805347     
E0 <- 3
I0 <- 1
R0 <- 0
D0 <- 0

# Parameter value 
alpha1 <- 1/225000000   
beta1 <- 1/7            
gamma1 <- 1/20
eta1 <- 1/35

Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                alpha1, beta1, gamma1, eta1, n1 )

# Error Function
Err1 <- function( S0, E0, I0, R0, D0,
                  alpha1, beta1, gamma1, eta1, n1,
                  us1 ){
  Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                  alpha1, beta1, gamma1, eta1, n1 ) 
  sum1 <- sum( ( us1$AdjInfect - Out1$I )^2 )
  sum2 <- sum( ( us1$Recovered - Out1$R )^2 )
  sum3 <- sum( ( us1$Deaths - Out1$D )^2 )
  sum4 <- sum1 + sum2 + sum3
  return( sum4 )
}

Err1( S0, E0, I0, R0, D0,
      alpha1, beta1, gamma1, eta1, n1,
      us1 )

# Goal is to minimize the error
#  f'(x) = lim ( f(x+h) - f(x) )/h
ErrSign1 <- function( S0, E0, I0, R0, D0,
                      alpha1, beta1, gamma1, eta1, n1,
                      us1 ){
  Err0 <- Err1( S0, E0, I0, R0, D0,
                alpha1, beta1, gamma1, eta1, n1,
                us1 )
  alpha1prime <- ( Err1( S0, E0, I0, R0, D0,
                        alpha1 + 1/175000000000, beta1, gamma1, eta1, n1,
                        us1 ) - Err0 )/( 1/175000000000 )
  beta1prime <- ( Err1( S0, E0, I0, R0, D0,
                       alpha1, beta1 + 1/700, gamma1, eta1, n1, 
                       us1 ) - Err0 )/( 1/700 )
  eta1prime <- ( Err1( S0, E0, I0, R0, D0,
                      alpha1, beta1, gamma1, eta1 + 1/3500, n1, 
                      us1 ) - Err0 )/( 1/3500 )
  gamma1prime <- ( Err1( S0, E0, I0, R0, D0,
                        alpha1, beta1, gamma1 + 1/2000, eta1 , n1,
                        us1 ) - Err0 )/( 1/2000 )
  Res1 <- sign( c( alpha1prime,
                   beta1prime,
                   gamma1prime,
                   eta1prime ) )
  return( Res1 )
}


StepSize1 <- c( 1/1000000000000000,     # step size for alpha1
                1/1000,                 # ... beta1
                1/2000,                 # ... gamma1
                1/5000 )                # ... eta1

# Update Parameters  ----------
# Update the parameters, this code will figure out which way to go to get smaller and make it happen
# Run this to update the parameters to minimize the squared loss

for( i in 1:100 ){
  StepSign1 <- ErrSign1( S0, E0, I0, R0, D0,
                        alpha1, beta1, gamma1, eta1, n1,
                        us1 ) 
  alpha1 <- alpha1 - StepSize1[ 1 ]*StepSign1[ 1 ]
  beta1 <- beta1 - StepSize1[ 2 ]*StepSign1[ 2 ]
  gamma1 <- gamma1 - StepSize1[ 3 ]*StepSign1[ 3 ]
  eta1 <- eta1 - StepSize1[ 4 ]*StepSign1[ 4 ]
  
  Out1 <- SEIRD1( S0, E0, I0, R0, D0,
                  alpha1, beta1, gamma1, eta1, n1 )
}


# Simple Plots  ----------

par( mfrow = c( 1, 3 ) )
# Recovered
plot( 1:n1, us1$Recovered, col = "seagreen", main = "US Recovered", xlab = "Number of Days" )
lines( 1:n1, Out1$R, col = "seagreen" )

# Infected
plot( 1:n1, us1$AdjInfect, col = "red", main = "US (Adjusted) Infected", xlab = "Number of Days" )
lines( 1:n1, Out1$I, col = "red" )

# Deaths
plot( 1:n1, us1$Deaths, col = "black", main = "US Deaths", xlab = "Number of Days" )
lines( 1:n1, Out1$D, col = "black" )


# Forecasting  ----------
n2 <- 300  # How long the process goes from start (180 days here)
Out2 <- SEIRD1( S0, E0, I0, R0, D0,
                alpha1, beta1, gamma1, eta1, n1 = n2)
par( mfrow = c(1,1) )
plot( 1:n1, us1$AdjInfect, col = "red",
      xlim = c(0,n2),
      ylim = c(0, max( Out2$I ) ),
      main = "Forecast of US Compartmental Model",
      xlab = "Number of days",
      ylab = "Number of People" )
lines( 1:n2, Out2$I, col = "red")
points( 1:n1, us1$Recovered, col = "seagreen")
lines( 1:n2, Out2$R, col = "seagreen")
points( 1:n1, us1$Deaths, col = "black" )
lines( 1:n2, Out2$D, col = "black")


# Goal 3: =======================================================================================
# To add complexity to the model add immigration to the model.   
# Explore what would happen if restrictions on immigration were not put in place.  
# Note that in Europe the Schengen Area (I think that is how you spell it) allows for free 
# movement of people across countries.  Explore if 0.01%, 0.05% of the population could move 
# from the neighboring country to your country.  Note that both Susceptible, Exposed and 
# Recovered people will move.  Assume that only Infected (Sick) people will remain.  Plot all 
# three scenarios on the same plot.  One plot for Infected with all three scenarios, one plot 
# for Recovered with all three scenarios and one plot for Deaths with all three scenarios.

#####################################################################
# 
# Immigration US -> UK 1%
# 
#####################################################################

S0 <- 67805347     # UK population
E0 <- 2            # Initial exposed, ten days before first 2 infected cropped up, 2 seems reasonable
I0 <- 0            # Infected
R0 <- 0            # Recovered
D0 <- 0            # Deaths

S1 <- 328239523     # US pop
E1 <- 3
I1 <- 1
R1 <- 0
D1 <- 0

# Parameter value 
alpha1 <- 4.444344e-09       # Parameter for infected UK
alpha2 <- -1.25003e-09        # intervention1
alpha3 <- -1.249982e-09          # intervention2
alpha4 <- -1.250048e-09          # intervention3
beta1 <- 0.1468571                   # Parameter for exposed -> infected
gamma1 <- 0.007                   # Parameter for recovered
eta1 <- 0.01857143                  # parameter for mortality

alpha_a <- 9.999e-10         # US parameters
beta_a <- 0.1548571
gamma_a <- 0.016
eta_a <- 0.01377143

chpt1 <- 58        # Time at which we believe intervention took place (quarantine etc)
chpt2 <- 65
chpt3 <- 74
n1 <- nrow( ukmainland1 )
SEIRD1 <- function( S0, E0, I0, R0, D0, S1, E1, I1, R1, D1,
                    alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1,
                    alpha_a, beta_a, gamma_a, eta_a,
                    chpt1, chpt2, chpt3){
  Out1 <- data.frame( S = rep( S0,n1 ),
                      E = rep( E0, n1 ),
                      I = rep( I0,n1 ),
                      R = rep( R0,n1 ),
                      D = rep( D0,n1 ) )
  Out2 <- data.frame( S1 = rep( S1,n1 ),
                      E1 = rep( E1, n1 ),
                      I1 = rep( I1,n1 ),
                      R1 = rep( R1,n1 ),
                      D1 = rep( D1,n1 ) )
  for( i in 2:n1 ){
    # 1% immigration
    Si <- round(S1*(0.01/n1))
    Ei <- round(E1*(0.01/n1))
    Ri <- round(R1*(0.01/n1))
    # US data first
    S1n <- S1 - Si
    E1n <- E1 - Ei
    I1n <- I1
    R1n <- R1 - Ri
    D1n <- D1
    S1 <- max(0, S1n - alpha_a*S1n*E1n )
    E1 <- max(0, E1n + alpha_a*S1n*E1n - beta_a*E1n )
    I1 <- max(0, I1n + beta_a*E1n - gamma_a*I1n - eta_a*I1n )
    R1 <- R1n + gamma_a*I1n
    D1 <- D1n + eta_a*I1n
    # UK data
    S0n <- S0 + Si
    E0n <- E0 + Ei
    I0n <- I0
    R0n <- R0 + Ri
    D0n <- D0
    intervention1 <- ifelse(i<chpt1, 0, 1)
    intervention2 <- ifelse(i<chpt2, 0, 1)
    intervention3 <- ifelse(i<chpt3, 0, 1)
    S0 <- max(0, S0n - (alpha1 + alpha2*intervention1 - alpha3*intervention2 + alpha4*intervention3)
              *S0n*E0n )
    E0 <- max(0, E0n + (alpha1 + alpha2*intervention1 - alpha3*intervention2 + alpha4*intervention3)
              *S0n*E0n - beta1*E0n )
    I0 <- max(0, I0n + beta1*E0n - gamma1*I0n - eta1*I0n )
    R0 <- R0n + gamma1*I0n
    D0 <- D0n + eta1*I0n
    Out1[ i, ] <- c( S0, E0, I0, R0, D0 )
    Out2[ i, ] <- c(S1, E1, I1, R1, D1)
  }
  Out3 <- cbind(Out1, Out2)
  return( Out3 )
}

Out3 <- SEIRD1( S0, E0, I0, R0, D0, S1, E1, I1, R1, D1,
                alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1,
                alpha_a, beta_a, gamma_a, eta_a,
                chpt1, chpt2, chpt3)


# Plot of initial model
plot( 1:n1, Out3$S, 
      type = "l",
      col = "purple",
      main = "Plot of the Model",
      ylab = "Number of People",
      xlab = "Number of Observations" )
lines( 1:n1, Out3$E, col = "orange" )
lines( 1:n1, Out3$I, col = "red " )
lines( 1:n1, Out3$R, col = "seagreen" )
lines( 1:n1, Out3$D, col = "black" )



par( mfrow = c(1,3) )
# Infected
plot( 1:n1, ukmainland1$AdjInfect, col = "red" )
lines( 1:n1, Out3$I, col = "red")

# par( mfrow = c(1,2) ) 
# Recovered
plot( 1:n1, ukmainland1$Recovered, col = "seagreen" )
lines( 1:n1, Out3$R, col = "seagreen")

# Deaths
plot( 1:n1, ukmainland1$Deaths, col = "black" )
lines( 1:n1, Out3$D, col = "black")


###############################
#
# Forecast for immigration 1% 
#
###############################
Out3 <- SEIRD1( S0, E0, I0, R0, D0, S1, E1, I1, R1, D1,
                alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1 = n2,
                alpha_a, beta_a, gamma_a, eta_a,
                chpt1, chpt2, chpt3)
n2 <- 300
par( mfrow = c(1,1) )
plot( 1:n1, ukmainland1$AdjInfect, col = "red",
      xlim = c(0,n2),
      ylim = c(0, max( Out3$D ) ) )
lines( 1:n2, Out3$I, col = "red")
points( 1:n1, ukmainland1$Recovered, col = "seagreen")
lines( 1:n2, Out3$R, col = "seagreen")
points( 1:n1, ukmainland1$Deaths, col = "black" )
lines( 1:n2, Out3$D, col = "black")


# All 3 cases on plot

plot( 1:n1, ukmainland1$AdjInfect, col = "red" )
lines( 1:n2, Out3$I, col = "red")
lines( 1:n2, Out2$I, col = "red", lty = 2 )
lines( 1:n2, Out1$I, col = "red", lty = 3 )

plot( 1:n1, ukmainland1$AdjInfect, col = "red",
      xlim = c(0,n2),
      ylim = c(0, max( Out3$D ) ) )
lines( 1:n2, Out3$I, col = "red")


plot( 1:n1, ukmainland1$AdjInfect, col = "red",
      xlim = c(0,n2),
      ylim = c(0, max( Out3$D ) ) )
lines( 1:n2, Out3$I, col = "red")



#####################################################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################


#####################################################################
# 
# Immigration US -> UK 5%
# 
#####################################################################

S0 <- 67805347     # UK population
E0 <- 2            # Initial exposed, ten days before first 2 infected cropped up, 2 seems reasonable
I0 <- 0            # Infected
R0 <- 0            # Recovered
D0 <- 0            # Deaths

S1 <- 328239523     # US pop
E1 <- 3
I1 <- 1
R1 <- 0
D1 <- 0

# Parameter value 
alpha1 <- 4.444344e-09       # Parameter for infected UK
alpha2 <- -1.25003e-09        # intervention1
alpha3 <- -1.249982e-09          # intervention2
alpha4 <- -1.250048e-09          # intervention3
beta1 <- 0.1468571                   # Parameter for exposed -> infected
gamma1 <- 0.007                   # Parameter for recovered
eta1 <- 0.01857143                  # parameter for mortality

alpha_a <- 9.999e-10         # US parameters
beta_a <- 0.1548571
gamma_a <- 0.016
eta_a <- 0.01377143

chpt1 <- 58        # Time at which we believe intervention took place (quarantine etc)
chpt2 <- 65
chpt3 <- 74
n1 <- nrow( ukmainland1 )
SEIRD1 <- function( S0, E0, I0, R0, D0, S1, E1, I1, R1, D1,
                    alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1,
                    alpha_a, beta_a, gamma_a, eta_a,
                    chpt1, chpt2, chpt3){
  Out1 <- data.frame( S = rep( S0,n1 ),
                      E = rep( E0, n1 ),
                      I = rep( I0,n1 ),
                      R = rep( R0,n1 ),
                      D = rep( D0,n1 ) )
  Out2 <- data.frame( S1 = rep( S1,n1 ),
                      E1 = rep( E1, n1 ),
                      I1 = rep( I1,n1 ),
                      R1 = rep( R1,n1 ),
                      D1 = rep( D1,n1 ) )
  for( i in 2:n1 ){
    # 1% immigration
    Si <- round(S1*(0.05/n1))
    Ei <- round(E1*(0.05/n1))
    Ri <- round(R1*(0.05/n1))
    # US data first
    S1n <- S1 - Si
    E1n <- E1 - Ei
    I1n <- I1
    R1n <- R1 - Ri
    D1n <- D1
    S1 <- max(0, S1n - alpha_a*S1n*E1n )
    E1 <- max(0, E1n + alpha_a*S1n*E1n - beta_a*E1n )
    I1 <- max(0, I1n + beta_a*E1n - gamma_a*I1n - eta_a*I1n )
    R1 <- R1n + gamma_a*I1n
    D1 <- D1n + eta_a*I1n
    # UK data
    S0n <- S0 + Si
    E0n <- E0 + Ei
    I0n <- I0
    R0n <- R0 + Ri
    D0n <- D0
    intervention1 <- ifelse(i<chpt1, 0, 1)
    intervention2 <- ifelse(i<chpt2, 0, 1)
    intervention3 <- ifelse(i<chpt3, 0, 1)
    S0 <- max(0, S0n - (alpha1 + alpha2*intervention1 - alpha3*intervention2 + alpha4*intervention3)
              *S0n*E0n )
    E0 <- max(0, E0n + (alpha1 + alpha2*intervention1 - alpha3*intervention2 + alpha4*intervention3)
              *S0n*E0n - beta1*E0n )
    I0 <- max(0, I0n + beta1*E0n - gamma1*I0n - eta1*I0n )
    R0 <- R0n + gamma1*I0n
    D0 <- D0n + eta1*I0n
    Out1[ i, ] <- c( S0, E0, I0, R0, D0 )
    Out2[ i, ] <- c(S1, E1, I1, R1, D1)
  }
  Out3 <- cbind(Out1, Out2)
  return( Out3 )
}

Out3 <- SEIRD1( S0, E0, I0, R0, D0, S1, E1, I1, R1, D1,
                alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1,
                alpha_a, beta_a, gamma_a, eta_a,
                chpt1, chpt2, chpt3)

par( mfrow = c(1,1) )
# Infected
plot( 1:n1, ukmainland1$AdjInfect, col = "red" )
lines( 1:n1, Out3$I, col = "red")

par( mfrow = c(1,2) ) 
# Recovered
plot( 1:n1, ukmainland1$Recovered, col = "seagreen" )
lines( 1:n1, Out1$R, col = "seagreen")

# Deaths
plot( 1:n1, ukmainland1$Deaths, col = "black" )
lines( 1:n1, Out1$D, col = "black")


###############################
#
# Forecast for immigration 5% 
#
###############################
Out3 <- SEIRD1( S0, E0, I0, R0, D0, S1, E1, I1, R1, D1,
                alpha1, alpha2, alpha3, alpha4, beta1, gamma1, eta1, n1 = n2,
                alpha_a, beta_a, gamma_a, eta_a,
                chpt1, chpt2, chpt3)
n2 <- 300
par( mfrow = c(1,1) )
plot( 1:n1, ukmainland1$AdjInfect, col = "red",
      xlim = c(0,n2),
      ylim = c(0, max( Out3$D ) ) )
lines( 1:n2, Out3$I, col = "red")
points( 1:n1, ukmainland1$Recovered, col = "seagreen")
lines( 1:n2, Out3$R, col = "seagreen")
points( 1:n1, ukmainland1$Deaths, col = "black" )
lines( 1:n2, Out3$D, col = "black")



