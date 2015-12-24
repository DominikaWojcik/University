-- Problem polega na tym, że funkcja fib ma złożoność wykładniczą
-- fib :: Integer -> Integer
-- fib 0 = 1
-- fib 1 = 1
-- fib n = fib(n-1)+fib(n-2)
-- Patrzcie i uczcie się, jak to się robi
fib :: Integer -> Integer
fib n = profib n 1 1
    where 
    profib :: Integer -> Integer -> Integer -> Integer
    profib 0 x _ = x
    profib m x y = profib (m-1) y (x+y)

lista = 1:1:(zipWith (+) lista (tail lista))
