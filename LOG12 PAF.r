library(psych)
library(GPArotation)
library(dplyr)

fa_data <- lew_data %>%
  select(
    CYNewWorldOrder, CYSARS, CYPearlHarbor, CYMLK, 
    CYMoon, CYArea51, CYJFK, CY911, CYRoswell, CYDiana, 
    CYOkla, CYCoke
  ) %>%
  na.omit()

eigenvalues <- eigen(cor(fa_data))$values
num_factors <- sum(eigenvalues > 1)

cat("Extracting", num_factors, "factors based on eigenvalues > 1\n\n")

fa_results <- fa(
  r = fa_data, 
  nfactors = num_factors, # Instead of fixing the number of factors in advance, I'm limiting the extraction to factors with eigenvalues greater than 1. See the code above.
  rotate = "oblimin",   
  fm = "pa",              # Principal Axis Factoring
  scores = "regression",  # Calculates factor scores using the regression method
  max.iter = 25,          # Maximum iterations for the factor extraction step
  maxit = 25              # Maximum iterations for the rotation step
)

print(fa_results, digits = 3, cut = 0.3, sort = TRUE)