def sciezka(graf, a, b)
    queue = Queue.new
    prev = {}
    prev[a] = a
    queue << a

    while !queue.empty?
        current = queue.pop
        break if current == b
        next if !graf[current]

        for neighbour in graf[current]
            if !prev[neighbour]
                prev[neighbour] = current
                queue << neighbour
            end
        end
    end

    path = []
    if prev[b]
        path << b
        current = b
        while prev[current] != current
            path << prev[current]
            current = prev[current]
        end
        path.reverse!
    end
     
    print "Sciezka z ", a, " do ", b, ": ", path, "\n"
end

def suma(a, b)
    tmp = a.clone
	suma!(tmp, b)
	return tmp;
end

def suma!(a, b)
    b.each {|v,e| 
        if !a[v]
            a[v] = e
        else
            a[v].push(*e)
            a[v].uniq!
        end
    }
end

wroclawWschod = {
    "Most Grunwaldzki" => ["Galeria Dominikanska", "Rondo Reagana", "Plac Wroblewskiego"],
    "Rondo Reagana" => ["Katedra", "Most Grunwaldzki", "Hala Stulecia"],
    "Katedra" => ["Galeria Dominikanska", "Rondo Reagana"],
    "Hala Stulecia" => ["Rondo Reagana"],
    "Galeria Dominikanska" => ["Dworzec PKP", "Most Grunwaldzki", "Katedra"],
    "Plac Wroblewskiego" => ["Most Grunwaldzki", "Dworzec PKP"],
    "Dworzec PKP" => ["Dworzec PKS", "Plac Wroblewskiego", "Galeria Dominikanska"],
    "Dworzec PKS" => ["Dworzec PKP"]
}

wroclawZachod = {
    "Galeria Dominikanska" => ["Rynek", "Dworzec PKP"],
    "Rynek" => ["Galeria Dominikanska", "Plac JP2"],
    "Plac JP2" => ["Rynek", "Dworzec Swiebodzki"],
    "Dworzec Swiebodzki" => ["Plac JP2", "Dworzec PKP", "Port Lotniczy"],
    "Dworzec PKP" => ["Galeria Dominikanska", "Dworzec Swiebodzki"],
    "Port Lotniczy" => ["Dworzec Swiebodzki"]
}

puts "--------------------------------------"
puts "PRZED POLACZENIEM"
puts "--------------------------------------"
puts "Wroclaw Wschod: "
puts( wroclawWschod.map{ |k,v| "\t#{k} => #{v}" })
puts "--------------------------------------"
puts "Wroclaw Zachod: "
puts( wroclawZachod.map{ |k,v| "\t#{k} => #{v}" })
puts "--------------------------------------"

puts "--------------------------------------"
puts "WROCŁAW WSCHÓD"
puts "--------------------------------------"

sciezka(wroclawWschod, "Hala Stulecia", "Dworzec PKS")
sciezka(wroclawWschod, "Most Grunwaldzki", "Katedra")
sciezka(wroclawWschod, "Galeria Dominikanska", "Plac Wroblewskiego")
sciezka(wroclawWschod, "Most Grunwaldzki", "Rynek")

puts "--------------------------------------"
puts "WROCŁAW ZACHÓD"
puts "--------------------------------------"

sciezka(wroclawZachod, "Galeria Dominikanska", "Port Lotniczy")
sciezka(wroclawZachod, "Rynek", "Port Lotniczy")

puts "--------------------------------------"
puts "BRAK POLACZENIA MIEDZY WSCHODEM A ZACHODEM"
puts "--------------------------------------"
sciezka(wroclawWschod, "Hala Stulecia", "Port Lotniczy")
sciezka(wroclawZachod, "Port Lotniczy", "Hala Stulecia")
puts "--------------------------------------"

puts "--------------------------------------"
puts "PO POLACZENIU"
puts "--------------------------------------"
puts "Wroclaw Wschod + Wroclaw Zachod"
wroclaw = suma(wroclawWschod, wroclawZachod)
puts( wroclaw.map{ |k,v| "\t#{k} => #{v}" })
puts "--------------------------------------"

puts "--------------------------------------"
sciezka(wroclaw, "Hala Stulecia", "Port Lotniczy")
sciezka(wroclaw, "Port Lotniczy", "Hala Stulecia")
puts "--------------------------------------"
