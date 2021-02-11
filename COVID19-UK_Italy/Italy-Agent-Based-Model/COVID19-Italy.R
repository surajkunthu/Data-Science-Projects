#######################################
# Suraj Kunthu
######################################

# In this project you will have a considerable amount of flexibility in how you model the populations.  
# You will need to try to match the Active Infections, Recovered and Deaths for your assigned country.  
# However, the complexity of the model is completely up to you.  If you go and seek other data to 
# incorporate into the model is totally up to you and your group.


# Read in the GlobalCovid19-2020-04-20.csv dataset
#  Data1 <- read.csv( file.choose(), header = TRUE )

# Subset the data
Italy1 <- Data1[ Data1$Country == "Italy", ]
Italy2 <- Italy1[ Italy1$Confirmed > 0, ]

# Make a column for Active Infections
Italy2$ActInfect <- Italy2$Confirmed - Italy2$Recovered - Italy2$Deaths
ItalyPop <- 60471111
# Plot Confirmed Cases
# plot( 1:nTime1, Italy2$Confirmed,
#       main = "Confirmed Cases in Italy",
#       xlab = "Number of Days",
#       ylab = "Number of Cases")


# Goal 1: =======================================================================================
# Fit a ABM to the best of your ability to the country you have been assigned.

# Functions from a previous lecture
# Build an agent
AgentBuild1 <- function( S0, E0, I0, R0, D0, nPop1){
  Agent1 <- data.frame( Status = rep( "S", nPop1),     # SEIRD
                        Mixing = runif( nPop1, 0, 1 ),  # How likely to mix?
                        TimeE = 0,
                        TimeI = 0,
                        stringsAsFactors = FALSE )
  Agent1$Status[1:E0] <- "E"
  Agent1$TimeE[1:E0] <- 1
  Agent1$Status[(E0+1):(E0 + I0) ] <- "I"
  Agent1$TimeI[(E0+1):(E0 + I0)] <- 1
  return( Agent1 )
}

# Move agents forward in time.
MoveForward1 <- function( Agent1, par1 ){
  nAgents1 <- nrow( Agent1 )   # How many agents do we have
  res1 <- Agent1               # Make a copy of Agent1 so we can change it.
  Index1 <- 1:nAgents1         # Generic index (naming)
  #
  # Work with Susceptibles first.
  Susept1 <- Index1[ res1$Status == "S" ] # Gives me a list of S
  for( i in Susept1 ){
    TempAgent1 <- Agent1[i,]   # Grab and agent
    # Determine the number of people the agent will mix with
    # on this day.
    nMix1 <- rpois( 1, TempAgent1$Mixing*par1$MeanMix ) + 1
    # Identify agents to mix with
    Mix1 <- sample( Index1, nMix1, replace = FALSE )
    if( nMix1 > 0 ){
      Mix1Temp <- Agent1[Mix1,]
      Temp1Expose <- ifelse( Mix1Temp$Status == "E",1,0)*rbinom( nMix1, 1, par1$S2E )
      if( max( Temp1Expose ) > 0 ){
        res1$Status[ i ] <- "E"
        #res1$TimeE[ i ] <- 1
      }
    }
  }
  # Grab people who have been exposed for at least 1 day.
  Expos1 <- Index1[ res1$Status == "E" ]
  # Adding one day to their exposure time.
  res1$TimeE[ Expos1 ] <- res1$TimeE[ Expos1 ] + 1
  # Grab people with 3 or more days since exposure
  Expos2 <- Index1[ res1$Status == "E" & res1$TimeE > 3 ]
  # Determine whether or not they become sick
  for( i in Expos2 ){
    Urand1 <- runif( 1, 0, 1 )
    if( Urand1 < par1$E2I ){
      res1$Status[i] <- "I"
    }
  }
  # Grab exposed people who were exposed 14 days ago
  Expos3 <- Index1[ res1$Status == "E" & res1$TimeE > 13 ]
  # Move these to the recovered bin.
  res1$Status[ Expos3 ] <- "R"
  # Grab people who are infected and add 1 to their infection time
  Infect1 <- Index1[ res1$Status == "I" ]
  res1$TimeI[ Infect1 ] <- res1$TimeI[ Infect1 ] + 1
  # Grab those who have been sick for more than 2 days
  Infect2 <- Index1[ res1$Status == "I" & res1$TimeI > 3 ]
  # Determine if they recover or ....
  for( i in Infect1 ){
    Urand1 <- runif( 1, 0, 1 )
    if( Urand1 < par1$I2D ){
      res1$Status[i] <- "D"
    }
  }
  # Grab people who have been sick a while
  Infect3 <- Index1[ res1$Status == "I" & res1$TimeI > 13 ]
  # Assign them as recovered
  res1$Status[ Infect3 ] <- "R"

  return( res1 )
}

ModelRun1 <- function( nTime1, Agent1, par1 ){
  # How far into the future
  # nTime1 <- 30
  # Make a container to hold results
  Out1 <- data.frame( S = rep( 0, nTime1 ),
                      E = rep( 0, nTime1 ),
                      I = rep( 0, nTime1 ),
                      R = rep( 0, nTime1 ),
                      D = rep( 0, nTime1 ) )

  # Loop through the time periods and store the results.
  for( i in 1:nTime1 ){
    Agent1 <- MoveForward1( Agent1, par1 )
    Out1$S[ i ] <- length( Agent1$Status[ Agent1$Status == "S" ] )
    Out1$E[ i ] <- length( Agent1$Status[ Agent1$Status == "E" ] )
    Out1$I[ i ] <- length( Agent1$Status[ Agent1$Status == "I" ] )
    Out1$R[ i ] <- length( Agent1$Status[ Agent1$Status == "R" ] )
    Out1$D[ i ] <- length( Agent1$Status[ Agent1$Status == "D" ] )
  }
  return( Out1)
}

# Parameters on how Agents interact with each other.
par1 <- data.frame( MeanMix = 15,     # Mean number of individuals a person could interact with
                    S2E = 0.075,
                    E2I = 0.45,
                    E2R = 0.000007,
                    I2R = 0.0067,
                    I2D = 0.0045 )

# Build Population
Agent1 <- AgentBuild1( S0 = 0, E0 = 1, I0 = 2,
                       R0 = 0, D0 = 0, nPop1 = 6047 )
# How many days in dataset
nTime1 <- nrow( Italy2 )/2 # This day was picked bc it was about ~6000 cases
# Run them through time
Out1 <- ModelRun1( nTime1, Agent1, par1 ) 
# Plot it
par( mfrow = c(1,3) )
# All values proportionate
# Infected
plot( 1:nTime1, Italy2$ActInfect[1:nTime1], col = "red",
      main = "Active Infected Model against Dataset",
      ylab = "Number of Infected",
      xlab = "Number of Days" )
lines( 1:nTime1, Out1$I, col = "red")
# Recovered
plot( 1:nTime1, Italy2$Recovered[1:nTime1], col = "seagreen",
      main = "Recovered Model against Dataset",
      ylab = "Number of Recovered",
      xlab = "Number of Days" )
lines( 1:nTime1, Out1$R, col = "seagreen")
# Deaths
plot( 1:nTime1, Italy2$Deaths[1:nTime1], col = "black",
      main = "Deaths Model against Dataset",
      ylab = "Number of Deaths",
      xlab = "Number of Days" )
lines( 1:nTime1, Out1$D, col = "black")


# How many days in dataset
# All Data in Italy2 -------
nTime2 <- nrow( Italy2 ) 
Out2 <- ModelRun1( nTime2, Agent1, par1 ) 
# All values proportionate
# Plot it
par( mfrow = c(1,3) )
# Infected
plot( 1:nTime2, Italy2$ActInfect[1:nTime2], col = "red",
      main = "Active Infected Model against Dataset",
      ylab = "Number of Infected",
      xlab = "Number of Days" )
lines( 1:nTime2, Out2$I, col = "red")
# Recovered
plot( 1:nTime2, Italy2$Recovered[1:nTime2], col = "seagreen",
      main = "Recovered Model against Dataset",
      ylab = "Number of Recovered",
      xlab = "Number of Days" )
lines( 1:nTime2, Out2$R, col = "seagreen")
# Deaths
plot( 1:nTime2, Italy2$Deaths[1:nTime2], col = "black",
      main = "Deaths Model against Dataset",
      ylab = "Number of Deaths",
      xlab = "Number of Days" )
lines( 1:nTime2, Out2$D, col = "black")

# Goal 2: =======================================================================================
# Present the model clearly with out using any computer code nor complex mathematics.
# (Pictures work incredibly well).

# Half the data in Italy2
# Plot of the Model
plot( 1:nTime1, Out1$S, type = "l", col = "purple",
      ylim = c(0,round(ItalyPop/10000)),
      main = "Proportioned Plot of the Model",
      ylab = "Number of People (Proportioned to 6047)",
      xlab = "Number of Days" )
lines( 1:nTime1, Out1$E , col = "orange" )
lines( 1:nTime1, Out1$I , col = "red" )
lines( 1:nTime1, Out1$R , col = "seagreen")
lines( 1:nTime1, Out1$D, col = "black")

# All Data in Italy2 
# Plot of the Model
plot( 1:nTime2, Out2$S, type = "l", col = "purple",
      ylim = c(0,round(ItalyPop/10000)),
      main = "Proportioned Plot of the Model",
      ylab = "Number of People (Proportioned to 6047)",
      xlab = "Number of Days" )
lines( 1:nTime2, Out2$E , col = "orange" )
lines( 1:nTime2, Out2$I , col = "red" )
lines( 1:nTime2, Out2$R , col = "seagreen")
lines( 1:nTime2, Out2$D, col = "black")

# Goal 3: =======================================================================================
# In real time run a scenario that predicts 3 days forward from a April 20, 2020 
# but the model has not be tuned to.  Demonstrate the predictive performance of your model.  
# You need to obtain the data for the remaining days on your own.  Furthermore, you will be 
# running your code live.  So make sure whatever the output you produce is easy to explain.

# Read in the GlobalCovid19-2020-04-27.csv dataset
Data2 <- read.csv( file.choose(), header = TRUE )

# Subset the data
Italy3 <- Data2[ Data2$Country == "Italy", ]
Italy4 <- Italy3[ Italy3$Confirmed > 0, ]

# Since we have more days than intended, cut off on April 23, 2020
Italy4 <- Italy4[1:84,]
# Parameters on how Agents interact with each other.
par1 <- data.frame( MeanMix = 15,     # Mean number of individuals a person could interact with
                    S2E = 0.075,
                    E2I = 0.45,
                    E2R = 0.000007,
                    I2R = 0.0067,
                    I2D = 0.0045 )

# Build Population
Agent1 <- AgentBuild1( S0 = 0, E0 = 1, I0 = 2,
                       R0 = 0, D0 = 0, nPop1 = 6047 )
# How many days in dataset
nTime1 <- 43 # This day was picked bc it was about ~6000 cases
# Make a column for Active Infections
Italy4$ActInfect <- Italy4$Confirmed - Italy4$Recovered - Italy4$Deaths


# All Data in Italy2 -------
nTime2 <- nrow( Italy4 ) 

# Run them through time
Out2 <- ModelRun1( nTime2, Agent1, par1 ) 
# All values proportionate
# Plot it
par( mfrow = c(1,3) )
# Infected
plot( 1:nTime2, Italy4$ActInfect[1:nTime2], col = "red",
      main = "Predicted Active Infected Model against Dataset",
      ylab = "Number of Infected",
      xlab = "Number of Days" )
lines( 1:nTime2, Out2$I, col = "red")
# Recovered
plot( 1:nTime2, Italy4$Recovered[1:nTime2], col = "seagreen",
      main = "Predicted Recovered Model against Dataset",
      ylab = "Number of Recovered",
      xlab = "Number of Days" )
lines( 1:nTime2, Out2$R, col = "seagreen")
# Deaths
plot( 1:nTime2, Italy4$Deaths[1:nTime2], col = "black",
      main = "Predicted Deaths Model against Dataset",
      ylab = "Number of Deaths",
      xlab = "Number of Days" )
lines( 1:nTime2, Out2$D, col = "black")



