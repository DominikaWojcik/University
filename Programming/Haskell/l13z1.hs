import Control.Monad
import Data.List

hetman :: Int -> [[Int]]
hetman n  = permH [1..n] where
    permH [] = return []
    permH xs = do
        x <- xs
        let xs' = delete x xs
        hs <- permH xs'
        guard(sprawdz x hs 1)
        return (x:hs)

    sprawdz _ [] _ = True
    sprawdz x (y:ys) odl = 
        abs (x-y) /= odl && sprawdz x ys (odl+1)
