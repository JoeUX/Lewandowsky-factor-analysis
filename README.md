# Lewandowsky-factor-analysis
This repo provides code to replicate the factor analysis in [Lewandowsky, Oberauer, and Gignac (2012)](https://journals.sagepub.com/doi/abs/10.1177/0956797612457686). 

That study purported to measure belief in various conspiracy theories, and had participants complete a questionnaire asking about 14 different conspiracies. Incredibly, they reported the identical factor loading – .742 – for all ten items in their main conspiracy belief factor. This means that the loadings are false, since they cannot be identical – it's not mathematically possible.

With this code, you can see the actual factor loadings as well as the principal components. It turns out the conspiracy belief latent variable presented by Lewandowsky, et al. doesn't exist. Few of the items loaded heavily on any factor, and participants generally didn't endorse the conspiracies.
