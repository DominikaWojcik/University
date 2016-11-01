def pierwsze n
    sito = [0] * (n+1)
    i = 2
    while i*i <= n
        if sito[i] == 0
            j = i*i
            while j <= n
                sito[j] = 1
                j += i
            end
        end
        i += 1
    end
    sito.each_index.select{|i| i >= 2 && sito[i] == 0}

end

print "Pierwsze 2", (pierwsze 2), "\n"
print "Pierwsze 3", (pierwsze 3), "\n"
print "Pierwsze 100", (pierwsze 100), "\n"
print "Pierwsze 1000", (pierwsze 1000), "\n"

