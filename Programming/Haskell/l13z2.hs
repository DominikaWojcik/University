newtype Random a = Random (Int -> (Int,a))
instance Monad Random where
    return x = Random (\s -> (s,x))
    (Random f) >>= g = Random (\s ->
        let
            (s',a) = f s
            (Random h) = g a
        in h s')

init :: Int -> Random ()
init n = Random (\_ -> (n,()))

random :: Random Int
random = Random (\seed ->
    let
        newSeed = 16807 * (seed `mod` 127773) - 2836 * (seed `div` 127773)
        retValue = if newSeed > 0 then newSeed else newSeed + 2147483647
    in (newSeed, retValue) ) 



