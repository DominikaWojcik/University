data Cyclist a = Elem (Cyclist a) a (Cyclist a) 
fromList :: [a] -> Cyclist a
fromList [] = undefined
fromList (x:xs) = this where
    this = Elem last x next
    (next,last) = aux this this xs

aux :: Cyclist a -> Cyclist a -> [a] -> (Cyclist a, Cyclist a)
aux first prev [] = (first, prev)
aux first prev (x:xs) = (this,last) where
    this = Elem prev x next
    (next,last) = aux first this xs

forward :: Cyclist a -> Cyclist a
forward (Elem _ _ r) = r

backwards :: Cyclist a -> Cyclist a
backwards (Elem l _ _) = l

label :: Cyclist a -> a
label (Elem _ x _) = x

enumInts :: Cyclist Integer
enumInts = aux2 0 where
    aux2 n = Elem (aux2 (n-1)) n (aux2 (n+1))


newtype Cyc a b = Cyc (Cyclist a -> (b,Cyclist a))
instance Monad (Cyc a) where
    return x = Cyc $ \cs -> (x,cs)
    (Cyc f) >>= g = Cyc $ \cs -> 
        let (value, newCyclist) = f cs
            (Cyc h) = g value
        in h newCyclist

runCyc :: Cyclist a -> Cyc a b -> b
runCyc cs (Cyc f) = fst.f $ cs

fwd :: Cyc a ()
fwd  = Cyc (\(Elem _ _ r)-> ((),r))

bkw :: Cyc a ()
bkw = Cyc (\(Elem l _ _)-> ((),l))

lbl :: Cyc a a
lbl = Cyc(\ cs@(Elem _ x _)-> (x,cs))

example :: Integer
example = runCyc enumInts (do
    bkw
    bkw
    bkw
    bkw
    x <- lbl
    fwd
    fwd
    y <- lbl
    fwd
    z <- lbl
    return (x+y+z))
