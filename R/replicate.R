# Estimation

library(brms)
library(shinystan)
library(plyr)
library(coda)

# setwd("CHANGE TO DIRECTORY ON YOUR MACHINE")

# Get processed data -- change to forward slashes on Windows.
load('./data/replicate.Rda')

#---------------------------------------------------------
# Helper functions
#---------------------------------------------------------

estimate.logit = function(model_formula, data, prior, seed=12345){
  # Function takes a model (specified as an R formula object), a
  # data frame, and prior specification and fits a Bayesian
  # multi-level logistic regression.
  #
  # Parameters:
  #------------
  # model_formula: a valid R formula object
  # data: data frame used for estimation
  # prior: a vector of prior specifications (see the set_prior function
  # in the brms package).
  # (option) seed: random seed for MCMC
  #
  # Returns:
  #---------
  # Returns a brmsfit object
  
  fit <- brm(formula = model_formula,
             data = dat, family = bernoulli(link = "logit"), 
             prior = prior,
             warmup = 2000, 
             iter = 5000, 
             chains = 4,
             control = list(adapt_delta = 0.99),
             seed = seed)
  
  return(fit)
}

get.model.formula = function(dv){
  # Helper function to return model formula
  b <- "vulnerable + z_obama08 + republican + other + govt_type + z_median_income + z_unemployment + z_log_population + z_temp_anomaly + z_log_press_release_n + (1|state_id/city_id) + (1|month_year)"
  return(as.formula(paste(dv, '~', b)))
}

get.credible.intervals = function(fit){
  # Function takes a fitted brms model and returns the mean
  # posterior estimate, 50%, and 95% credible intervals for
  # each covariate of interest
  #
  # Parameters:
  #------------
  # fit: a brmsfit object
  #
  # Returns:
  #---------
  # Returns a dataframe of estimation results
  
  # Subset regression parameters
  post_b = post[,grep('b_*', names(post))]
  
  # Get point estimates
  ests <- as.data.frame(apply(post_b, 2, mean))
  
  # Get credible intervals
  ci50 <- as.data.frame(t(apply(post_b, 2, quantile, probs= c(.25,.75))))
  ci95 <- as.data.frame(t(apply(post_b, 2, quantile, probs= c(.025,.975))))
  
  # Combine results and return
  res = as.data.frame(cbind(ests, ci50, ci95))
  names(res) = c("estimate", "lower_50", "upper_50", "lower_95", "upper_95")
  return(res)
}

# If you want to explore predicted probabililties...
inverse_logit <- function(x) {
  return(1/(1+exp(-x)))
}

#---------------------------------------------------------
# Estimates: "General discussion" of climate change
#---------------------------------------------------------

# Specify priors
prior = c(set_prior("normal(0, 1)", class = "b"),
          set_prior("cauchy(0, 2.5)", class = "sd"))

# Estimate
model_formula = get.model.formula("dum_climenergy")
fit_general = estimate.logit(model_formula, dat, prior=prior)

# Post-estimation
ests_general = get.credible.intervals(fit_general)

#---------------------------------------------------------
# Estimates: "Explicit discussion" of climate change
#---------------------------------------------------------

# Specify priors
prior = c(set_prior("normal(0, 1)", class = "b"),
          set_prior("cauchy(0, 2.5)", class = "sd"))

# Estimate
model_formula = get.model.formula("dum_climonly")
fit_explicit = estimate.logit(model_formula, dat, prior=prior)

# Post-estimation
ests_explicit = get.credible.intervals(fit_explicit)

