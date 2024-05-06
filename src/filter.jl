# Exercise 1.2(b)

using Plots
include("utils.jl")

length0 = 0.125
f0 = 1e9
z0 = 50
z1 = 98.45
z2 = 101.6
z3 = 43.6
zOpen = Inf

function reflectionCoefFilter(freq::Real)
    length = newLength(length0, freq, f0)

    zOpen1 = zInput(z1, zOpen, length)
    zOpen2 = zInput(z3, zOpen, length)
    zOpen3 = zInput(z1, zOpen, length)

    zA = parallel(z0, zOpen1)
    zBprep = zInput(z2, zA, length)
    zB = parallel(zBprep, zOpen2)

    zCprep = zInput(z2, zB, length)
    zC = parallel(zCprep, zOpen3)

    return abs(reflectionCoef(z0, zC))
end

N = 201
# N = 1001
# freqSweep = 0:3*f0/N:3*f0 
# freqSweep = 0:1000:3*f0
freqSweep = 0:3*f0/N:9*f0 
# freqSweep = 1999980000:1000:2000020000

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
                color="red",
                xlabel="Frequency [GHz]", 
                ylabel="SWR"
                )

pl = plot(filterReflectionPlot, filterSWRPlot, layout=(2,1), legend=false)
savefig(pl, "../docs/media/1-2-b_1.png")
