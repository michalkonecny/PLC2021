module SimulateFP where

evalBitsInt :: [Integer] -> Integer
evalBitsInt bits = 
    sum (zipWith (*) (reverse bits) (map (2^) [0..]))

evalBitsFrac :: [Integer] -> Double
evalBitsFrac bits = 
    sum (zipWith (*) (map fromInteger bits) (map (2^^) [-1,-2..]))

decodeFP_3_3 :: [Integer] -> [Integer] -> Double
decodeFP_3_3 exponentBits mantissaBits =
    let exponent = evalBitsInt exponentBits - 3 in
    let mantissa = 1 + (evalBitsFrac mantissaBits) in
    let mantissa0 = (evalBitsFrac mantissaBits) in
    let isDenormalised = exponent == -3 in
    let isInfinityOrNaN = exponent == 4 in
    let infinity = 1/0 in
    let nan = 0/0 in
    if isDenormalised 
        then mantissa0 * (2^^(-2))
        else if not isInfinityOrNaN
            then mantissa * (2^^exponent)
            else if mantissa0 == 0 
                then infinity
                else nan
