# Exercise 1.2(c)

using Plots
include("utils.jl")

f0 = 1e9
z0 = 50
zH = 150
zL = 20

electric_lengths_deg = [21.903, 31.426, 37.720, 31.426, 21.903]
lengths = electric_lengths_deg ./ 360

function reflectionCoefFilter(freq::Real) 
    newLengths = newLength.(lengths, freq, f0)

    zA = zInput(zH, z0, newLengths[5])
    zB = zInput(zL, zA, newLengths[4])
    zC = zInput(zH, zB, newLengths[3])
    zD = zInput(zL, zC, newLengths[2])
    zE = zInput(zH, zD, newLengths[1])

    return abs(reflectionCoef(z0, zE))
end

N = 201
freqSweep = 0:2*f0/N:2*f0

Γ = reflectionCoefFilter.(freqSweep)
SWRs = SWR.(Γ)
SWRs[SWRs .> 10] .= 10
SWRs[SWRs .< 1] .= 1

dbGamma = dB.(Γ)
dbGamma[dbGamma .< -60] .= -60
dbGamma[dbGamma .> 0] .= 0

filterReflectionPlot = plot(
                    freqSweep ./ 1e9, dbGamma, 
                    xlabel="Frequency [GHz]",
                    ylabel="Γ [dB]"
                    )

filterSWRPlot = plot(
                freqSweep ./ 1e9, SWRs,
                color = "red",
                xlabel="Frequency [GHz]", 
                ylabel="SWR"
                )

pl = plot(filterReflectionPlot, filterSWRPlot, layout=(2,1), legend=false)


