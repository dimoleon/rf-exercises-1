
parallel(z1::Number, z2::Number) = (z1^-1 + z2^-1)^-1

dB(num::Real) = 20log10(num)

newLength(baseLength::Real, freq::Real, baseFreq::Real) = baseLength * freq / baseFreq

function zInput(z0::Number, zLoad::Number, length::Real) 
    if !isfinite(zLoad)
        return -im * z0 * cot(2π * length)
    end
    return z0 * (zLoad + im*z0*tan(2π*length)) / (z0 + im*zLoad*tan(2π*length))
end

reflectionCoef(z0::Number, zLoad::Number) = (zLoad - z0) / (zLoad + z0)

captoZ(cap::Real, freq::Real) = -im/(2π * freq * cap)
selfIndtoZ(l::Real, freq::Real) = im * 2π * freq * l

function newZ(z::Number, freq::Real, baseFreq::Real) 
    x = z.im
    if (x < 0)
        c = 1 / (2π * baseFreq * x) 
        return z.re + captoZ(c, freq)
    end
    l = x / (2π * baseFreq)
    return z.re + selfIndtoZ(l, freq)
end

SWR(reflCoef) = (1 + reflCoef)/(1 - reflCoef)

function power(Vrms::Real, zGen::Number, zIn::Number) 
    rGen, xGen = zGen.re, zGen.im
    rIn, xIn = zIn.re, zIn.im
    pow = (Vrms^2) * rIn / ((rIn + rGen)^2 + (xIn + xGen)^2)
    return pow
end