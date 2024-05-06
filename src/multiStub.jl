# Exercise 1.4

using Statistics
include("utils.jl")

z0 = 50
zLoad = 120 + 60im
# zLoad = 20 + 30im
# zLoad = 180 - 200im

normf = 0.5 : 0.01 : 1.5
normf2 = 0.01 : 0.01 : 2

function reflectionCoefMultiStub(freqRatio::Real, p::Vector{Float64}) 
    halfLength = length(p) ÷ 2  
    # arrLength == 6 || throw(DimensionMismatch("p vector must have 6 elements"))

    d = newLength.(p[1:halfLength], freqRatio, 1)
    l = newLength.(p[halfLength + 1:end], freqRatio, 1)

    zOpen = zInput.(z0, Inf, l)

    zMainLine = newZ(zLoad, freqRatio, 1)
    for i ∈ 1:halfLength
        zMainLine = zInput(z0, zMainLine, d[i])
        zMainLine = parallel(zMainLine, zOpen[i])
    end

    return abs(reflectionCoef(z0, zMainLine))
end

function reflectionCoefSimulation(p::Vector{Float64})  
    return reflectionCoefMultiStub.(normf, Ref(p))
end

function reflectionCoefSimulationMean(p::Vector{Float64})
    return mean(reflectionCoefSimulation(p))
end

function reflectionCoefSimulationPlot(p::Vector{Float64})
    y = ones(length(normf2))*0.3
    plot(normf2, [reflectionCoefSimulation2(p), y],
            xlabel="Normalized Frequency", 
            ylabel="Γ",
            legend=false
            )
end

function reflectionCoefSimulation2(p::Vector{Float64}) 
    return reflectionCoefMultiStub.(normf2, Ref(p))
end

function reflectionCoefSimulationMean2(p::Vector{Float64})
    return mean(reflectionCoefSimulation2(p))
end

function bandwidthCounter(p::Vector{Float64})
    check(x) = x <= 0.3
    return -count(check, reflectionCoefSimulation2(p))
end

function bandwidthCounterWeighted(p::Vector{Float64})
    check(x) = x <= 0.3
    sum = 0
    simRes = reflectionCoefSimulation2(p)
    for i ∈ eachindex(simRes)[2:end]
        if (check(simRes[i]))
            sum += 1
            if (check(simRes[i - 1]))
                sum += 1
            end
        end
    end
    return -sum
end
