import Data.List
import Data.Char

intToStr :: Int -> String

intToStr x
    |x == 0 = "0"
    |x < 0 = "-" ++ intToStr(-x)
    |otherwise = reverse $ unfoldr f x
        where f x = if x==0 then Nothing else Just(intToDigit $ fromEnum $  x `mod` 10, x `div` 10)
