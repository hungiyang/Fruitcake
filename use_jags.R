model = "model
{
	# Phil's true height in cm
	height ~ dnorm(175, 1/20^2)

	# True weight in kg
	

	# Student-t parameters
	log_sigma ~ dunif(-10, 10)
	sigma <- exp(log_sigma)
	log_nu ~ dunif(0, 5)
	nu <- exp(log_nu)

	# Likelihood
	for(i in 1:N)
	{
		log_height_guesses[i] ~ dt(log(height), 1/sigma^2, nu)
	}
}
"

# The data (use NA for no data)
data = list(log_height_guesses=log(c(170, 120, 180, 172, 168)), N=5)

# Variables to monitor
variable_names = c('height')

# How many burn-in steps?
burn_in = 1000

# How many proper steps?
steps = 10000

# Thinning?
thin = 1

# Random number seed
seed = 42


# NO NEED TO EDIT PAST HERE!!!
# Just run it all and use the results list.

library('rjags')

# Write model out to file
fileConn=file("model.temp")
writeLines(model, fileConn)
close(fileConn)

if(all(is.na(data)))
{
	m = jags.model(file="model.temp", inits=list(.RNG.seed=seed, .RNG.name="base::Mersenne-Twister"))
} else
{
	m = jags.model(file="model.temp", data=data, inits=list(.RNG.seed=seed, .RNG.name="base::Mersenne-Twister"))
}
update(m, burn_in)
draw = jags.samples(m, steps, thin=thin, variable.names = variable_names)
# Convert to a list
make_list <- function(draw)
{
	results = list()
	for(name in names(draw))
	{
		# Extract "chain 1"
		results[[name]] = as.array(draw[[name]][,,1])
		
		# Transpose 2D arrays
		if(length(dim(results[[name]])) == 2)
			results[[name]] = t(results[[name]])
	}
	return(results)
}
results = make_list(draw)
