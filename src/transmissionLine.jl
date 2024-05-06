# Exercise 1.1 + 1.2(a)

using Plots
using Printf
include("utils.jl")

z0 = 50.
f0 = 1e9
rLoad = 100.
cap = 2e-12
zOpen = Inf

lengths = [0.32, 0.24, 0.1]

function reflectionCoefTEMCircuit(freq::Real) 
    newLengths = newLength.(lengths, freq, f0)
    zCap = captoZ(cap, freq)
    
    zA = zInput(z0, rLoad, newLengths[1])
    zB = zA + zCap
    zFirst = zInput(z0, zB, newLengths[2])
    zSecond = zInput(z0, zOpen, newLengths[3])
    zTotal = parallel(zFirst, zSecond)

    return abs(reflectionCoef(z0, zTotal))
end

N = 201
freqSweep = 0:4*f0/N:4*f0

Γ0 = reflectionCoefTEMCircuit(f0)
SWR0 = SWR(Γ0)
@printf("Reflection coefficient for frequency %.2f GHz: %.3f\n", f0/1e9, Γ0)
@printf("Standing Wave Ratio for frequency %.2f GHz: %.3f\n", f0/1e9, SWR0)

f1 = 4*f0/3
Γ1 = reflectionCoefTEMCircuit(f1)
SWR1 = SWR(Γ1)
@printf("Reflection coefficient for frequency %.2f GHz: %.3f\n", f1/1e9, Γ1)
@printf("Standing Wave Ratio for frequency %.2f GHz: %.3f", f1/1e9, SWR1)

Γ = reflectionCoefTEMCircuit.(freqSweep)

reflCoefPlotNominal = plot(freqSweep ./ 1e9, Γ, 
                            xlabel = "Frequency [GHz]", 
                            ylabel = "Γ [Nominal]",
                            )

reflCoefPlotDB = plot(freqSweep ./ 1e9, dB.(Γ), 
                        xlabel="Frequency [GHz]", 
                        ylabel="Γ [dB]",
                        color="orange" 
                        )

pl = plot(reflCoefPlotNominal, reflCoefPlotDB, layout=(2,1), legend=false)
