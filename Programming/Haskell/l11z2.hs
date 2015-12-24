ssm :: Ord a => [a]->[a]
ssm xs = foldr (\x -> \ys -> x:(dropWhile(\z->z<=x) ys)) [] xs
