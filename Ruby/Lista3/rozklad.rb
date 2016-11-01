def rozklad n
    wyniki = []
    i=2
    while i*i <= n
        if n % i == 0
            wyniki << [i,0]
            while n % i == 0 && n > 1
                n /= i
                wyniki[-1][1] += 1 
            end
        end
        i = i + 1
    end
    wyniki << [n,1] if n > 1
    return wyniki
end

testy = [0,1,2,4,1025,1337,2**16,2**3 * 3**3 * 5**3 * 17 ** 1, 2323232, 230939494993]
for n in testy
    print "Rozklad ", n, " : ", (rozklad n), "\n"
end

