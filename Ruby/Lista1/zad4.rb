#!/usr/bin/ruby

def poddzielniki n
    wyniki = []
    i=2
    while i*i <= n
        if n % i == 0
            wyniki << i
            n /= i while n % i == 0 && n > 1
        end
        i = i + 1
    end
    wyniki << n if n > 1
    wyniki
end

testy = [0,1,2,4,1025,1337,2**16,2**3 * 3**3 * 5**3 * 17 ** 1, 2323232, 230939494993]
for n in testy
    print "Poddzielniki ", n, " : ", (poddzielniki n), "\n"
end
