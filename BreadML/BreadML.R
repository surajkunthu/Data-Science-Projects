# Suraj Kunthu
# Bakery Data Analysis
###################################

# Load libraries
library( "ANN2" )

# Read in the Bread.csv Dataset:
bread1 <- read.csv( file.choose(), head = TRUE )
head( bread1 ) # check to see what the data looks like

# Set up our data
Normalize1 <- function( X1 ){
  res1 <- ( X1 - min( X1 ) )/( max( X1 ) - min( X1 ) )
  return( res1 )
}

# Normalize all the data to be between 0 and 1
TasteN <- Normalize1( bread1$Taste )
TextureN <- Normalize1( bread1$Texture )
CrustN <- Normalize1( bread1$Crust )
TempN <- Normalize1( bread1$Temperature )
HumidN <- Normalize1( bread1$Humidity )
BakeN <- Normalize1( bread1$BakeTime )
Proof1N <- Normalize1( bread1$Proof1 )
Proof2N <- Normalize1( bread1$Proof2 )
CoatN <- Normalize1( bread1$Coating )
OilN <- Normalize1( bread1$Oil )
EggN <- Normalize1( bread1$Egg )
LiquidN <- Normalize1( bread1$PctLiquid )
BakeTempN <- Normalize1( bread1$BakeTemp )

# Put all of this into a dataframe
bread2 <- data.frame( Taste = TasteN,
                      Texture = TextureN,
                      Crust = CrustN,
                      Temperature = TempN,
                      Humidity = HumidN,
                      BakeTime = BakeN,
                      Proof1 = Proof1N,
                      Proof2 = Proof2N,
                      Coating = CoatN,
                      Oil = OilN,
                      Egg = EggN,
                      PctLiquid = LiquidN,
                      BakeTemp = BakeTempN )

# Split up the data by rows
n1 <- nrow( bread1 ) #7238
set.seed( 16 )
train1index <- sample( 1:n1, size = 5000, replace = FALSE )
train1 <- bread2[ train1index, ]
valid1 <- bread2[ -train1index, ]

# Make sure the splitting is working properly
nrow( train1 )
nrow( valid1 )

##########################################################################

# For Taste

# Train the data for a numeric outcome
ann1 <- neuralnetwork( train1[ , 4:13 ], # We don't need the 14th column
                                         # because we don't think day of the year is necessary
                       train1[ , 1 ],    # we are testing Taste
                       hidden.layers = c( 10, 20, 20, 10 ),
                       activ.functions = "relu", # add this to help
                       regression = TRUE, 
                       loss.type = "squared")

# Generate some predictions
pred.valid1 <- predict( ann1, newdata = valid1[, 4:13 ] )

# predicting how long the part lasted before it was replaced
SSPE1 <- sum( ( pred.valid1$predictions - valid1[ , 1 ] )^2 )
plot( valid1[ , 1 ], pred.valid1$predictions ) # should look like a 45 degree angle
# type SSPE2 into console to get a number, the smaller the better
SSPE1


# Train the data longer to see if it becomes more accurate
train( ann1, train1[ , 4:13 ], train1[ , 1 ] )
pred.valid1 <- predict( ann1, newdata = valid1[ , 4:13 ] )

# predicting how long the part lasted before it was replaced
SSPE1 <- sum( ( pred.valid1$predictions - valid1[ , 1 ] )^2 )
plot( valid1[ , 1 ], pred.valid1$predictions ) # should look like a 45 degree angle
# type SSPE1 into console to get a number, the smaller the better
SSPE1




##########################################################################

# For Texture

# Train the data for a numeric outcome
ann2 <- neuralnetwork( train1[ , 4:13 ],    # We don't need the 14th column
                                            # because we don't think day of the year is necessary
                       train1[ , 2 ],       # we are testing Texture
                       hidden.layers = c( 10, 20, 20, 10 ),
                       activ.functions = "relu", # add this to help
                       regression = TRUE, 
                       loss.type = "squared")

# Generate some predictions
pred.valid2 <- predict( ann2, newdata = valid1[, 4:13 ] )

# predicting how long the part lasted before it was replaced
SSPE2 <- sum( ( pred.valid2$predictions - valid1[ , 2 ] )^2 )
plot( valid1[ , 2 ], pred.valid2$predictions ) # should look like a 45 degree angle
# type SSPE2 into console to get a number, the smaller the better
SSPE2

# Train the data longer to see if it becomes more accurate
train( ann2, train1[ , 4:13 ], train1[ , 2 ] )
pred.valid1 <- predict( ann2, newdata = valid1[, 4:13 ] )
SSPE2 <- sum( ( pred.valid2$predictions - valid1[ , 2 ] )^2 )
plot( valid1[ , 2 ], pred.valid2$predictions )
SSPE2

##########################################################################

# For Crust

# Train the data for a numeric outcome
ann3 <- neuralnetwork( train1[ , 4:13 ], # We dont need the 14th column
                       # because we don't think day of the year is necessary
                       train1[ , 3 ], # we are testing Crust
                       hidden.layers = c( 10, 20, 20, 10 ),
                       activ.functions = "relu",# add this to help
                       regression = TRUE, 
                       loss.type = "squared" )

# Generate some predictions
pred.valid3 <- predict( ann3, newdata = valid1[, 4:13 ] )
SSPE3 <- sum( ( pred.valid3$predictions - valid1[ , 3 ] )^2 )
plot( valid1[ , 3], pred.valid3$predictions )
SSPE3

# Train the data longer to see if it becomes more accurate
train( ann2, train1[ , 4:13 ], train1[ , 2 ] )
pred.valid3 <- predict( ann3, newdata = valid1[, 4:13 ] )
SSPE3 <- sum( ( pred.valid3$predictions - valid1[ , 3 ] )^2 )
plot( valid1[ , 3 ], pred.valid3$predictions )
SSPE3

##########################################################################

# Sum of all SSPE's
SSPETotal <- SSPE1 + SSPE2 + SSPE3
SSPETotal
