# Exercise 1.3(c)

using Plots
include("utils.jl")

f0 = 1e9
zLoad = 10 + 15im
z0 = 50 
zGen = 50 - 40im
Vrms = 1

caps = [4.7, 3.0, 2.8]*1e-12
lengths = [0.099, 0.039, 0.138]

# capacitor parallel to load
function powerSolutionA(freq::Real)
    zCap = captoZ(caps[1], freq)
    length = newLength(lengths[1], freq, f0)
    zL = newZ(zLoad, freq, f0)

    zA = parallel(zL, zCap)
    zIn = zInput(z0, zA, length)

    return power(Vrms, zGen, zIn)
end 

# capacitor parallel to zInput
function powerSolutionB(freq::Real)
    zCap = captoZ(caps[2], freq)
    length = newLength(lengths[2], freq, f0)
    zL = newZ(zLoad, freq, f0)

    zB = zInput(z0, zL, length)
    zIn = parallel(zCap, zB)

    return power(Vrms, zGen, zIn)
end

# capacitor in series with zInput
function powerSolutionC(freq::Real)
    zCap = captoZ(caps[3], freq)
    length = newLength(lengths[3], freq, f0)
    zL = newZ(zLoad, freq, f0)

    print
    zC = zInput(z0, zL, length)
    zIn = zC + zCap
    
    return power(Vrms, zGen, zIn)
end

N = 201
freqSweep = 0 : 2*f0/N : 2*f0

function plotPower(solution::Function)
    powerArr = solution.(freqSweep)
    return pl = plot!(freqSweep ./ 1e9, powerArr .* 1e3, 
                legend=false
                )
end

y = ones(length(freqSweep))*2.5
plTotal = plot()
plotPower(powerSolutionA)
plotPower(powerSolutionB)
plotPower(powerSolutionC)
plot!(freqSweep ./ 1e9, y)
plot!(xlabel="Frequency [GHz]", ylabel="Power [mW]", legend=false) 


