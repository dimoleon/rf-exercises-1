# Exercise 1.4

using Evolutionary
using Plots
include("utils.jl")
include("multiStub.jl")

lowerBound = [0, 0.05, 0.05, 0, 0, 0]
upperBound = ones(6)
bounds = BoxConstraints(lowerBound, upperBound)
ga = GA(populationSize = 1000, selection=tournament(5), crossover=SPX, mutation=PLM())
options = Evolutionary.Options(iterations=1000, show_trace=true) 

result = Evolutionary.optimize(reflectionCoefSimulationMean, 
                                bounds, 
                                ga, 
                                options)

pOptimal = Evolutionary.minimizer(result)
gammaMeanMin = Evolutionary.minimum(result)

pl = reflectionCoefSimulationPlot(pOptimal)