#!/usr/bin/ruby

def dajCyfre(x)
    case x
    when 1
        ["  X",
         " XX",
         "X X",
         "  X",
         "  X",
         "  X"]
    when 2
        [" XX ",
         "X  X",
         "  X ",
         " X  ",
         "X   ",
         "XXXX"]
    when 3
        [" XXXX ",
         "X   XX",
         "   XX ",
         "   XX ",
         "X   XX",
         " XXXX "]
    when 4
        ["   X",
         "  XX",
         " X X",
         "XXXX",
         "   X",
         "   X"]
    when 5
        ["XXXXX",
         "X    ",
         "XXXXX",
         "    X",
         "X   X",
         "XXXXX"]
    when 6
        ["XXX ",
         "X   ",
         "XXXX",
         "X  X",
         "X  X",
         "XXXX"]
    when 7
        ["XXXXX",
         "    X",
         "    X",
         "   X ",
         "  X  ",
         " X   "]
    when 8
        ["XXXX",
         "X  X",
         "XXXX",
         "XXXX",
         "X  X",
         "XXXX"]
    when 9
        ["XXXXX",
         "X   X",
         "XXXXX",
         "    X",
         "    X",
         "XXXXX"]
    else
        ["XXXX",
         "X  X",
         "X  X",
         "X  X",
         "X  X",
         "XXXX"]
    end 
end

def dajSpacje()
    return [" ",
            " ",
            " ",
            " ",
            " ",
            " "]
end

def sklej(a, b)
    for i in 0..a.length-1
        a[i] = a[i] + b[i]
    end
    return a
end

def parsuj(n)
    cyfra = dajCyfre(n % 10)
    if n < 10
        cyfra
    else
        sklej(sklej(parsuj(n / 10), dajSpacje()), cyfra) 
    end
end

def wielkaliczba(n)
    puts parsuj(n)
end

wielkaliczba(1234567890)
