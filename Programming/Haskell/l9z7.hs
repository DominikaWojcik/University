newtype FSet a = FSet (a->Bool)

empty::FSet a
empty = FSet (\_ -> False)

singleton :: Ord a => a -> FSet a
singleton x = FSet (\y -> if x==y then True else False)

fromList :: Ord a => [a] -> FSet a
fromList xs = FSet (\x -> if x `elem` xs then True else False)

union :: Ord a => FSet a -> FSet a -> FSet a
union (FSet f) (FSet g) = FSet (\x -> f x || g x)

intersection :: Ord a => FSet a -> FSet a -> FSet a
intersection (FSet f) (FSet g) = FSet (\x -> f x && g x)

member :: Ord a => a -> FSet a -> Bool
member x (FSet f) = f x
