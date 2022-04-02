Note 0
Sampling algorithms for various parametric distributions.

[0] Computational Statistics, Givens G.H, Hoeting, J.A., Ch. 6
[1] A simple method for generating gamma variables, Marsaglia G., Tsang W.,
ACM Transactions on Mathematical Software Volume 26, Issue 3, Sept. 2000,
https://doi.org/10.1145/358407.358414
)

cocurrent 'sampling'

NB. Standard Uniform sample (mondaic verb).
NB. Parameters:
NB.	y: positive int: number of values to return.
NB. Returns:
NB.	y values in the range [0,1],
NB. 	taken from independent uniform distributions.
uniformSample=: ?@:#&0

NB. Samples from a Normal Distribution, parameterized  by
NB. by mean, mu, and standard deviation, sigma.
NB. Parameters:
NB. 	y:
NB.		mu: mean of distribution, any float.
NB.		sigma: std. dev. of distribution, any float.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
normalSample=: 3 : 0"1
NB.    plot #/.~ /:~  <. 10 * normalSample 0 1 5000
'mu sigma num'=. y
ct=. 0
res=. ''
while. num >: ct=. ct+1 do.
  'u1 u2'=. uniformSample 2
  res=. res, {. mu + sigma * (%: _2 * ^. u1) * 1 2 o. (+: u2 * o. 1)
end.
res
)

NB. Samples from the Cauchy Distribution, parameterized by the values
NB. a and b,
NB. Parameters:
NB. 	y:
NB.		a: location, any float.
NB.		b: scale value, any float > 0.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
cauchySample=: 3 : 0"1
NB. plot #/.~ /:~ <.k [k=: cauchySample 0 1 90000
'a b num'=. y
ct=. 0
res=. ''
while. num >: ct=. ct+1 do.
  u1=. uniformSample 1
  res=. res, a + b * 3 o. (u1 - 0.5 )* o.1
end.
res

)

NB. Samples from the Exponential Distribution, parameterized
NB. by the values lambda,
NB. Parameters:
NB. 	y:
NB.		lambda: the expected value, any float > 0.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
exponentialSample=: 3 : 0"1
NB. plot #/.~ /:~ <.100*k  [k=: exponentialSample 10 1000
'lambda num'=. y
ct=. 0
res=. ''
while. num >: ct=. ct+1 do.
  u1=. uniformSample 1
  res=. res, - (^. u1) % lambda
end.
res
)

NB. Samples from the Poisson Distribution, parameterized
NB. by the values lambda,
NB. Parameters:
NB. 	y:
NB.		lambda: the expected value, any float > 0.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
poissonSample=: 3 : 0"1
NB. plot    #/.~ /:~ <.k [k=: poissonSample 2.222 10000
'lambda num'=: y
poissonx"0 num # lambda
)

poissonx=: 3 : 0"1
'argument should be in bound (0,_)' assert y > 0
p=. 1
j=. 0
exp=: ^ - y
while. p > exp do.
  j=. j+1
  u=. uniformSample 1
  p=. p*u
end.
j-1
)

NB. Samples from the Gamma Distribution, parameterized
NB. by the values r and lambda (scale),
NB. Parameters:
NB. 	y:
NB.		r: the shape, any float > 0.
NB.		lambda: the scale, any float > 0.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
gammaSample=: 3 : 0"1
'r lambda n'=. y
'r must be a postiive real value' assert r > 0
'lambda must be a postiive real value' assert lambda > 0
if. 'integer' -: datatype r do.
  gamma"1[>n $< r, lambda
else.
  gammaSampleReal y
end.
)


NB. for non-integer real values of r. The method for this
NB. is different to the method for integer values of r, using
NB. a rejection sampling method. (see [1])
gammaSampleReal=: 3 : 0
'r lambda n'=. y
res=: ''
c=: 0
if. r < 1 do.
  f=: gammaSampleReal (r+1), lambda, n
  us=: uniformSample #f
  f * us^%r
  return.
end.
while. c < n do.
  c=: c+1
  a=: r - 1r3
  b=: % %: 9* a
  t=: 3 :'a*(1+b*y)^3'
  qq=: 3 : '^ (-:*:t y) + (a * ^.a%~t y) +(-t y) + a'
  us=. uniformSample 1
  yz=. {.normalSample 0 1 1
  vv=. qq yz
  if. 0 < t yz do.
    if. us <: vv do.
      res=: res, t yz
    end.
  end.
end.
res % lambda
)


gamma=: 3 : 0
'r lambda'=. y
us=. uniformSample r
-lambda %~ +/ ^. us
)
 
NB. Samples from the Gamma Distribution, parameterized
NB. by the values a and b,
NB. Parameters:
NB. 	y:
NB.		a: the first parameter, any float > 0.
NB.		b: the second parameter, any float > 0.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
betaSample=: 3 : 0
'a b num'=. y
'a must be > 0' assert a > 0
'b must be > 0' assert b > 0
'a must be an integer' assert a -: <.a
'b must be an integer' assert b -: <.b
ct=. 0
res=. ''
while. num >: ct=. ct+1 do.
  g1=. gammaSample a,1,1
  g2=. gammaSample b,1,1
  res=. res, g1 % g1+g2
end.
res
)

NB. Samples from the Binomial Distribution, parameterized
NB. by the values n and p, where n is the number of 
NB. bernoulli trials and p is the probability of success 
NB. per trial.
NB. Parameters:
NB. 	y:
NB.		n: number of bernoulli trials, positive integer.
NB.		p: prob. of success per trial, any float > 0.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
binomialSample=: 3 : 0"1
'n p num'=. y
k=. ($ uniformSample@:(*/)) n, num
+/ k < p
)

NB. Samples from the Negative Binomial Distribution, parameterized
NB. by the values r and p, wherer is the number of failed 
NB. bernoulli trials before success and p is the probability of success 
NB. per trial.
NB. Parameters:
NB. 	y:
NB.		r: number of failed bernoulli trials, positive integer.
NB.		p: prob. of success per trial, any float > 0.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
binomialNegativeSample=: 3 : 0"1
'r p num'=. y
'r must be an integer' assert (<'integer') -: datatype r
'num must be an integer' assert (<'integer') -: datatype r
'r must be positive' assert r > 0
'p must be positive' assert p > 0
'num must be positive' assert num > 0
k=. ($ uniformSample@:(*/)) r, num
+/<.(1-p) %~ k 
)

NB. Samples from the Dirichlet Distribution, parameterized
NB. by the values a1,a2,a3,a4, a list of positive real numbers.
NB. Parameters:
NB. 	y:
NB.		alphas: the respective parameters of the
NB.		       gamma distributions.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
NB.        The shape of the returned data is (num, #alphas)
dirichletSample=: 3 : 0
'alphas num'=: y
'# alphas must be > 1' assert 1 < # alphas
res=. a:
for_i. i. num do.
  gs=: gammaSample"1 (alphas ,. 1) ,. 1
  res=. res,< (] % +/ ) , gs
end.
>}.res
)


NB. Samples from the Laplace Distribution, parameterized
NB. by the values a and b, where a is the mean / center, 
NB. and b is the measure of spread.
NB. Parameters:
NB. 	y:
NB.		a: center of the distribution (real value)
NB.		b: spread of the distribution (positive real value)
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
laplaceSample=: 3 : 0
'a b num'=: y
'b must be positive' assert b > 0
us=: 0.5-~uniformSample num
a- b * (^.@:-@:<:@:+:@:|**)us
)

NB. Samples from the Chi-Squared Distribution, parameterized
NB. by the values mu, sigma, count, where mu is the mean of the constituent Normal 
NB. distributions, sigma is the variance, and count is the number 
NB. of such constituent distributions.
NB. Parameters:
NB. 	y:
NB.		mu: mean of normal (real value)
NB.		sigma: variance of normal (positive real value)
NB.		count: number of normal distributions.
NB.		num: number of variables to return.
NB. Returns:
NB.	'num' values, each sampled form the above distribution.
chiSqSample=: 3 : 0
'mu sigma count num'=. y

'sigma must be > 0' assert sigma > 0
'count must be > 0' assert sigma > 0
'num must be > 0' assert sigma > 0
res=. ''
for_i. i. num do.
  res=. res, +/ *: normalSample mu ,sigma ,count
end.
res
)
 