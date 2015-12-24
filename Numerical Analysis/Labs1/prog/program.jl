#########################################################################################
# Autor: Jarosław Dzikowski 273233
# Zadanie: 11 - metoda Δ Aitkena
#
# Na początku znajdują się funkcje potrzebne do aplikacji metody Aitkena na ciąg.
# Następnie przeprowadzane są doświadczenia.
# Każdy z rozważanych ciągów ma swoją funkcję "ciag" generującą n pierwszych wyrazów
# danego ciągu.
# Wypisywane będą błędy bezwzględne ciągów:
# "err" będzie oznaczać błąd bezwzględny oryginalnego ciągu
# "errΔ" będzie oznaczać błąd bezwzględny ciągu jednokrotnie przyspieszonego
# "errΔΔ" będzie oznaczać błąd bezwzględny ciągu wielokrotnie przyspieszonego
### METODA AITKENA ######################################################################

# Wyznacza pojedynczy wyraz przyspieszonego ciągu
function Δ(a::BigFloat, b::BigFloat, c::BigFloat)
  return (a*c - b^2)/(c + -2.0*b + a)
end

# Wyznacza pojedynczy wyraz przyspieszonego ciągu alternatywną metodą
function alternateΔ(a::BigFloat, b::BigFloat, c::BigFloat)
  return a - (a - b)^2/(c + -2.0*b + a)
end

# Pobiera ciąg i zwraca przyspieszony ciąg
function delta(lista)
  wyrazy = BigFloat[]
  for i= 1 : (length(lista)-2)
    push!(wyrazy, alternateΔ(lista[i], lista[i+1], lista[i+2]))
  end
  return wyrazy
end

# Pobiera n oraz ciąg, a następnie zwraca n-krotnie przyspieszony ciąg
function delta_acceleration(n::Int, lista)
  wyrazy = lista
  for k = 1:n
    wyrazy = delta(wyrazy)
  end
  return wyrazy
end

### DOŚWIADCZENIA ###########################################################################

### PIERWSZY CIĄG - ZBIEŻNY PODLINIOWO #####################################################
lim1 = BigFloat(0.7853981634)

function ciag1(n::Int) # zwraca wyrazy [0 .. n] ciągu1
  wyrazy = BigFloat[]
  last = 1.0
  for i=1:n
    push!(wyrazy, last+((-1.0)^i)/(2.0*i+1.0))
    last = pop!(wyrazy)
    push!(wyrazy,last)
  end
  return wyrazy
end

wyniki1 = ciag1(20300)
println("PIERWSZY CIAG")
println("##########################")

# Zadanie a)
println("Zadanie a)")
println("##########################")

wyniki1Δ = delta_acceleration(1, wyniki1)

for i=1:3
  println (i, ": ", " \nerr: ", abs(wyniki1[i]-lim1),
           " \nerrΔ: ", abs(wyniki1Δ[i]-lim1))
end
for i=20:20
  println (i, ": ", " \nerr: ", abs(wyniki1[i]-lim1),
           " \nerrΔ: ", abs(wyniki1Δ[i]-lim1))
end
for i=20000:20000
  println (i, ": ", " \nerr: ", abs(wyniki1[i]-lim1),
           " \nerrΔ: ", abs(wyniki1Δ[i]-lim1))
end
println("##########################")

# Zadanie b)
println("Zadanie b)")
println("##########################")

wyniki1ΔΔ = delta_acceleration(2,wyniki1)

for i=1:3
  println (i, ": ", " \nerrΔ: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
for i=20:20
  println (i, ": ", " \nerrΔ: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
for i=20000:20000
  println (i, ": ", " \nerrΔ: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
println("##########################")

# Zadanie c)
println("Zadanie c)")
println("##########################")
println("Dziesięciokrotne przyspieszenie")
println("##########################")
wyniki1ΔΔ = delta_acceleration(10,wyniki1)

for i=1:3
  println (i, ": ", " \nerrΔ: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
for i=20:20
  println (i, ": ", " \nerrΔ: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
for i=20000:20000
  println (i, ": ", " \nerrΔ: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
println("##########################")
println("Dwudziestokrotne przyspieszenie")
println("##########################")
wyniki1ΔΔ = delta_acceleration(20,wyniki1)

for i=1:3
  println (i, ": ", " \nerr: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
for i=20:20
  println (i, ": ", " \nerr: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
for i=20000:20000
  println (i, ": ", " \nerr: ", abs(wyniki1Δ[i]-lim1),
            " \nerrΔ: ", abs(wyniki1ΔΔ[i]-lim1))
end
println("##########################")

### DRUGI CIĄG - ZBIEŻNY PODLINIOWO ########################################################################
lim2 = BigFloat(2.612375348685488)

function ciag2(n::Int)
  wyrazy = BigFloat[]
  for i = 1:n
    suma = 0.0
    for j = i:-1:1
      suma = suma + (1.0 / (j * sqrt(j)))
    end
    push!(wyrazy, suma)
  end
  return wyrazy
end

wyniki2 = ciag2(20300)
println("DRUGI CIĄG")
println("##########################")

#Zadanie a)
println("Zadanie a)")
println("##########################")

wyniki2Δ = delta_acceleration(1, wyniki2)
for i=1:3
  println (i, ": ", " \nerr: ", abs(wyniki2[i]-lim2),
           " \nerrΔ: ", abs(wyniki2Δ[i]-lim2))
end
for i=20:20
  println (i, ": ", " \nerr: ", abs(wyniki2[i]-lim2),
           " \nerrΔ: ", abs(wyniki2Δ[i]-lim2))
end
for i=20000:20000
  println (i, ": ", " \nerr: ", abs(wyniki2[i]-lim2),
           " \nerrΔ: ", abs(wyniki2Δ[i]-lim2))
end
println("##########################")

# Zadanie b)
println("Zadanie b)")
println("##########################")

wyniki2ΔΔ = delta_acceleration(2, wyniki2)

for i=1:3
  println (i, ": "," \nerrΔ: ", abs(wyniki2Δ[i]-lim2),
           " \nerrΔΔ: ", abs(wyniki2ΔΔ[i]-lim2))
end
for i=20:20
  println (i, ": "," \nerrΔ: ", abs(wyniki2Δ[i]-lim2),
           " \nerrΔΔ: ", abs(wyniki2ΔΔ[i]-lim2))
end
for i=20000:20000
  println (i, ": "," \nerrΔ: ", abs(wyniki2Δ[i]-lim2),
           " \nerrΔΔ: ", abs(wyniki2ΔΔ[i]-lim2))
end
println("##########################")

# Zadanie c)
println("Zadanie c)")
println("##########################")

wyniki2ΔΔ = delta_acceleration(10, wyniki2)

println("Dziesięciokrotne przyspieszenie:")
println("##########################")
for i=1:3
  println (i, ": "," \nerrΔ: ", abs(wyniki2Δ[i]-lim2),
           " \nerrΔΔ: ", abs(wyniki2ΔΔ[i]-lim2))
end

for i=20000:20000
  println (i, ": "," \nerrΔ: ", abs(wyniki2Δ[i]-lim2),
           " \nerrΔΔ: ", abs(wyniki2ΔΔ[i]-lim2))
end

wyniki2ΔΔ = delta_acceleration(20, wyniki2)

println("##########################")
println("Dwudziestokrotne przyspieszenie:")
println("##########################")
for i=1:5
  println (i, ": "," \nerrΔ: ", abs(wyniki2Δ[i]-lim2),
           " \nerrΔΔ: ", abs(wyniki2ΔΔ[i]-lim2))
end
for i=20000:20000
  println (i, ": "," \nerrΔ: ", abs(wyniki2Δ[i]-lim2),
           " \nerrΔΔ: ", abs(wyniki2ΔΔ[i]-lim2))
end
println("##########################")

### TRZECI CIĄG - ZBIEŻNY KWADRATOWO ###############################################################################
lim3 = BigFloat(0.0)

function ciag3(n::Int)
  wyrazy = BigFloat[]
  for i = 1:n
    push!(wyrazy,(1.0/(2.0^(BigFloat(2)^i))))
  end
  return wyrazy
end

wyniki3 = ciag3(30)
println("TRZECI CIĄG")
println("##########################")

# Zadanie a)
println("Zadanie a)")
println("##########################")

set_bigfloat_precision(512)
wyniki3Δ = delta_acceleration(1,wyniki3)
for i=1:5
  println (i, ": "," \nerr: ", abs(wyniki3[i]-lim3),
            " \nerrΔ: ", abs(wyniki3Δ[i]-lim3))
end
println("##########################")

# Zadanie b)
println("Zadanie b)")

wyniki3ΔΔ = delta_acceleration(2, wyniki3)
for i=1:6
  println (i, ": "," \nerrΔ: ", abs(wyniki3Δ[i]-lim3),
          " \nerrΔΔ: ", abs(wyniki3ΔΔ[i]-lim3))
end
println("##########################")

# Zadanie c)
println("Zadanie c)")
println("##########################")

set_bigfloat_precision(1024)
wyniki3ΔΔ = delta_acceleration(3, wyniki3)
println("Trzykrotne przyspieszenie:")
println("##########################")
for i=1:5
  println (i, ": "," \nerrΔ: ", abs(wyniki3Δ[i]-lim3),
          " \nerrΔΔ: ", abs(wyniki3ΔΔ[i]-lim3))
end

set_bigfloat_precision(2028)
wyniki3ΔΔ = delta_acceleration(4, wyniki3)
println("##########################")
println("Czterokrotne przyspieszenie:")
println("##########################")
for i=1:5
  println (i, ": "," \nerrΔ: ", abs(wyniki3Δ[i]-lim3),
          " \nerrΔΔ: ", abs(wyniki3ΔΔ[i]-lim3))
end

set_bigfloat_precision(128)
println("##########################")

### CZWARTY CIĄG - ZBIEŻNY PODLINIOWO ##############################################################################
lim4 = BigFloat(pi^4 / 90.0)

function ciag4(n::Int)
  wyrazy = BigFloat[]
  suma = BigFloat(0)
  for i = 1:n
    suma+= BigFloat(1.0/i^4)
    push!(wyrazy,suma)
  end
  return wyrazy
end

wyniki4 = ciag4(20300)
println("CZWARTY CIĄG")
println("##########################")

# Zadanie a)
println("(Zadanie a)")
println("##########################")

wyniki4Δ = delta_acceleration(1,wyniki4)
for i = 1:3
  println (i, ": ", " \nerr: ", abs(wyniki4[i]-lim4),
           " \nerrΔ: ", abs(wyniki4Δ[i]-lim4))
end
for i = 20:20
  println (i, ": ", " \nerr: ", abs(wyniki4[i]-lim4),
           " \nerrΔ: ", abs(wyniki4Δ[i]-lim4))
end

for i = 20000:20000
  println (i, ": ", " \nerr: ", abs(wyniki4[i]-lim4),
           " \nerrΔ: ", abs(wyniki4Δ[i]-lim4))
end
println("##########################")

# Zadanie b)
println("Zadanie b)")
println("##########################")

wyniki4ΔΔ = delta_acceleration(2,wyniki4)
for i = 1:3
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end
for i = 20:20
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end
for i = 50:50
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end
println("##########################")

# Zadanie c)
println("Zadanie c)")
println("##########################")

wyniki4ΔΔ = delta_acceleration(10,wyniki4)
println("Dziesięciokrotne przyspieszenie:")
println("##########################")
for i = 1:3
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end
for i = 20:20
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end
for i = 50:50
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end

wyniki4ΔΔ = delta_acceleration(20,wyniki4)
println("##########################")
println("Dwudziestokrotne przyspieszenie:")
println("##########################")
for i = 1:3
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end
for i = 20:20
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end
for i = 50:50
  println (i, ":", "\nerrΔ: ", abs(wyniki4Δ[i]-lim4),
        " \nerrΔΔ: ", abs(wyniki4ΔΔ[i]-lim4))
end

println("##########################")

### PIĄTY CIĄG - ZBIEŻNY PODLINIOWO #############################################################################
lim5 = BigFloat(0)

function ciag5(n::Int)
  wyrazy = BigFloat[]
  for i = 1:n
    if mod(i,2) == 0
      push!(wyrazy, BigFloat(i^(-0.25)))
    else
      push!(wyrazy, BigFloat(-(i^(-0.25))))
    end
  end
  return wyrazy
end

wyniki5 = ciag5(20300)
println("PIĄTY CIĄG")
println("##########################")

#Zadanie a)
println("Zadanie a)")
println("##########################")

wyniki5Δ = delta_acceleration(1,wyniki5)
for i = 1:3
  println (i, ": "," \nerr: ", abs(wyniki5[i]-lim5),
          " \nerrΔ: ", abs(wyniki5Δ[i]-lim5))
end
for i = 20:20
  println (i, ": "," \nerr: ", abs(wyniki5[i]-lim5),
          " \nerrΔ: ", abs(wyniki5Δ[i]-lim5))
end
for i = 20000:20000
  println (i, ": "," \nerr: ", abs(wyniki5[i]-lim5),
          " \nerrΔ: ", abs(wyniki5Δ[i]-lim5))
end

println("##########################")

# Zadanie b)
println("Zadanie b)")
println("##########################")

wyniki5ΔΔ = delta_acceleration(2,wyniki5)
for i = 1:3
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end
for i = 20:20
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end
for i = 20000:20000
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end

println("##########################")

# Zadanie c)
println("Zadanie c)")
println("##########################")

wyniki5ΔΔ = delta_acceleration(10,wyniki5)
println("Dziesięciokrotne przyspieszenie:")
println("##########################")
for i = 1:3
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end
for i = 20:20
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end
for i = 20000:20000
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end

wyniki5ΔΔ = delta_acceleration(20,wyniki5)
println("##########################")
println("Dwudziestokrotne przyspieszenie")
println("##########################")
for i = 1:3
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end
for i = 20:20
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end
for i = 20000:20000
  println (i, ": "," \nerrΔ: ", abs(wyniki5Δ[i]-lim5),
           " \nerrΔΔ: ", abs(wyniki5ΔΔ[i]-lim5))
end

println("##########################")

### SZÓSTY CIĄG - ZBIEŻNY LINIOWO ###############################
# W tym przypadku nie ma zbyt wiele do sprawdzania: każdy wyraz
# ciągu przyspieszonego jest zerem
#################################################################
lim6 = BigFloat(0)

function ciag6(n::Int)
  wyrazy = BigFloat[]
  for i = 1:n
    push!(wyrazy,BigFloat(1/2)^i)
  end
  return wyrazy
end

wyniki6 = ciag6(60)

wyniki6Δ = delta_acceleration(1,wyniki6)
println("SZÓSTY CIĄG")
println("##########################")
println("Tylko zadanie a)")
println("##########################")

for i=1:5
  println (i, ": \n", "err: ", abs(wyniki6[i]-lim6),
           "\nerrΔ: ", abs(wyniki6Δ[i]-lim6))
end
println("##########################")

