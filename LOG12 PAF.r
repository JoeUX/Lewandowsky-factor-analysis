library(haven)
library(psych)
library(GPArotation)
library(dplyr)
library(gt)
library(webshot2)

# --- CONFIG ---
# Specify our output folder for the factor loading tables (use forward slashes for R).
output_dir <- "C:/<choose a folder>/ROut"

# I don't have Chrome installed, so webshot2 needs to know where my Chromium browser is. (Edge, Brave, and Opera are all Chromium browsers.)
Sys.setenv(CHROMOTE_CHROME = "C:/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe")

# Import the SPSS file
lew_data <- read_sav("C:/<your path>/Lewandowsky.sav")

# View the first few rows to make sure it loaded correctly
head(lew_data)

# Define your variable order. (This is the same order as in the journal article.)
my_vars <- c("CYNewWorldOrder", "CYSARS", "CYPearlHarbor", "CYMLK", 
             "CYMoon", "CYJFK", "CY911", "CYDiana", "CYOkla", 
             "CYCoke", "CYRoswell", "CYArea51")

# --- PREPARE DATA ---

fa_data <- lew_data %>%
  select(all_of(my_vars)) %>%
  na.omit()

# --- RUN FACTOR ANALYSIS ---

eigenvalues <- eigen(cor(fa_data))$values
num_factors <- sum(eigenvalues > 1)  # Pull the factors with eigenvalues greater than 1.

cat("Extracting", num_factors, "factors based on eigenvalues > 1\n\n")

fa_results <- fa(
  r = fa_data, 
  nfactors = num_factors, # Instead of fixing the number of factors in advance, I limit the extraction to factors with eigenvalues greater than 1.
  rotate = "oblimin",   
  fm = "pa",              # Principal Axis Factoring
  normalize = TRUE,       # Key for matching SPSS FA results. By default, SPSS applies Kaiser Normalization before rotating. This weights variables equally so that one variable doesn't dominate the rotation. The psych package defaults to FALSE here.
  scores = "regression",  # Calculates factor scores using the regression method
  max.iter = 25,          # Maximum iterations for the factor extraction step
  maxit = 25              # Maximum iterations for the rotation step
)

# --- FORMAT TABLE ---
# Extract loadings
loadings_df <- as.data.frame(unclass(fa_results$loadings))
loadings_df$Variable <- rownames(loadings_df)

# Force the row order to match our list
loadings_df <- loadings_df[match(my_vars, loadings_df$Variable), ]

# Create the gt table
table_image <- loadings_df %>%
  select(Variable, everything()) %>%
  gt() %>%
  tab_header(
    title = md("**Factor Loadings**"),
    subtitle = "Pattern Matrix (Direct Oblimin)"
  ) %>%
  fmt_number(
    columns = -Variable,
    decimals = 3
  ) %>%
  opt_stylize(style = 6, color = "blue") %>%
  cols_align(align = "center", columns = -Variable)

# --- SAVE FILES ---
# file.path() ensures the slashes are handled correctly for Windows

# Save the HTML file
gtsave(table_image, filename = file.path(output_dir, "factor_loadings.html"))

# Save the PNG image
gtsave(table_image, filename = file.path(output_dir, "factor_loadings.png"), expand = 10)

# Print confirmation to console
cat("Files saved successfully to:", output_dir, "\n")
