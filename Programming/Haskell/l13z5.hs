import Control.Monad
import Data.List

tails1:: [a]->[[a]]
tails1 [] = [[]]
tails1 xs@(x:xs') = (xs:tails1 xs')

tails2:: [a]->[[a]]
tails2 [] = [[]]
tails2 xs@(x:xs') = xs:[ys| ys<- tails2 xs']

type Generator = []
tails3 :: [a] -> Generator [a]
tails3 [] = return []
tails3 xs@(x:xs') = return xs `mplus` tails3 xs'
                
