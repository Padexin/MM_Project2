# MM_Project2

This is the README file for our second Math Modeling project. It's on the subject of the population of scrub lizards native to Florida; we are meant to model said population. 

10/25/2020 -- Chris

I will probably start with the discrete logistical model; I think this would be helpful because we can later make the carrying capacity C dependent on our research into scrub lizards. So we are looking at the equation

X(n+1) = X(n) + kX(n)(C - X(n))


Clutch Size:

Something to think about is fitting kX(n)(C - X(n)) to our average clutch size, y = 0.21 * (SVL) - 7.5, where SVL is avg female size. I'm going to first try k = y


Age Groups:

I need to consider age groups. We have 4 of them, x0, x1, x2, x3. x1-3 can reproduce; x0 cannot. x0 is given to us by our previous generations. I'm going to have to modify the logistical model to be able to do this

x0(n+1) = (k1x1(n) + k2x2(n) + k3x3(n))(C - (x0(n) + x1(n) + x2(n) + x3(n))

x1(n+1) = x0(n)(1 - d0) //d0 is the death rate of x0

x2(n+1) = x1(n)(1 - d1) //d1 is the death rate of x1

x3(n+1) = x2(n)(1 - d2) //d2 is the death rate of x2


Reproduction Rates:

We have k = 0.21 * (SVL) - 7.5; then

k1 = 0.21(45.8) - 7.5 = 2.118

k2 = 0.21(55.8) - 7.5 = 4.218

k3 = 0.21(56.0) - 7.5 = 4.26


Death Rates:

I am computing these based on Number of Living Females. 

d0 = (495 - 92)/495 * 100% = 81.4%

d1 = (92 - 11)/92 * 100% = 91.9%

d2 = (11 - 2)/11 * 100% = 81.8%

d3 = 100%

Post-Model Note: These death rates were too high, and killed off the population too fast for them to successfully reproduce; I subtracted 0.2 from each of them. Refer to "growing.png" and "shrinking.png" to see low vs. high death rates respectively. I attempted to use some sort of formula to introduce the carrying capacity into the death rates, but it made things weird (refer to "carrying.png")


Problems with this currently:

	-Carrying capacity is arbitrarily chosen
	
	-In fact, carrying capacity doesn't come into the model at all
	
	-Reproduction rates k are a little arbitrary; or rather, I think they could be further tuned
	
	-Death rates are arbitrary
	
