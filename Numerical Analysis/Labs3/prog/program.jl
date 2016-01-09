#=
  Zadanie 3.11: Mebda Romberga
  Aubr: Jarosław Dzikowski 273233
=#

# Złożona metoda trapezów
function CompositeTrapezoidRule(a, b, n::Int, f)
  h = (b - a)/n
  sum = 0.0

  for i = 0:n
    if i == 0 || i == n
      sum += 0.5 * f(a + i*h)
    else
      sum += func(a + i*h)
    end
  end

  return sum * h
end

# Metoda Romberga Tworząca co najwyżej K poziomów tablicy
# lub przerywająca działanie gdy
# |T_m,0 - T_(m-1),0| <= ϵ|T_m,0|
function RombergsMethodEpsilon(a, b, f, K::Int, eps)
  T = zeros(K, K)
  T[1,1] = CompositeTrapezoidRule(a, b, 1, f)

  # Sprytne liczenie T_0,k (wartość f w każdym punkcie dodajemy tylko raz)
  h = (b - a)
  for i = 1:K-1
    h /= 2.0
    for j = 0:2^(i-1)-1
      T[1,i+1] += f(a + 2*h*j + h)
    end
    T[1,i+1] *= h
    T[1,i+1] += T[1,i] / 2.0
  end

  # Tworzymy kolejne rzędy tablicy T
  # Wartości liczników i,j są takie jak wyraz tablicy Romberga,
  # który chcemy obliczyć (T_i,j).
  # W Julii komórki tablicy indeksuje się niestety od 1,
  # dlatego obliczam T[i+1,j+1].
  for i = 1:K-1
    for j = 0:K-1-i
      T[i+1,j+1] = ((4.0^i)*T[i,(j+1)+1] - T[i,j+1])/ (4.0^i - 1)
    end
    if abs(T[i+1,1] - T[i,1]) < eps * abs(T[i+1,1])
      return T[i+1,1]
    end
  end
  return T[K,1]
end

# Metoda Romberga wyliczająca zawsze K wierszy tablicy
# i zwracająca T_(K-1),0
function RombergsMethodK(a, b, f, K::Int)
  T = zeros(K, K)
  T[1,1] = CompositeTrapezoidRule(a, b, 1, f)

  # Sprytne liczenie T_0,k (wartość f w każdym punkcie dodajemy tylko raz)
  h = (b - a)
  for i = 1:K-1
    h /= 2.0
    for j = 0:2^(i-1)-1
      T[1,i+1] += f(a + 2*h*j + h)
    end
    T[1,i+1] *= h
    T[1,i+1] += T[1,i] / 2.0
  end

  # Tworzymy kolejne rzędy tablicy T
  # Wartości liczników i,j są takie jak wyraz tablicy Romberga,
  # który chcemy obliczyć (T_i,j).
  # W Julii komórki tablicy indeksuje się niestety od 1,
  # dlatego obliczam T[i+1,j+1].
  for i = 1:K-1
    for j = 0:K-1-i
      T[i+1,j+1] = ((4.0^i)*T[i,(j+1)+1] - T[i,j+1])/ (4.0^i - 1)
    end
  end
  return T[K,1]
end

# Wypisuje tablicę błędów względnych metody Romberga
# K - liczba poziomów tabeli
# I - dokładna wartość całki
function PrintErrorTable(f, a, b, K, I)
  T = zeros(K, K)
  T[1,1] = CompositeTrapezoidRule(a, b, 1, f)

  h = (b - a)
  for i = 1:K-1
    h /= 2.0
    for j = 0:2^(i-1)-1
      T[1,i+1] += f(a + 2*h*j + h)
    end
    T[1,i+1] *= h
    T[1,i+1] += T[1,i] / 2.0
  end

  # Tworzymy kolejne rzędy tablicy T
  for i = 1:K-1
    for j = 0:K-1-i
      T[i+1,j+1] = ((4.0^i)*T[i,(j+1)+1] - T[i,j+1])/ (4.0^i - 1)
    end
  end

  # Wypisujemy tablicę błędów
  for i = 0:K-1
    for j = 0:i
      print(abs((I - T[j+1,i-j+1]) / I), "\t")
    end
    print("\n")
  end


end

### TESTY ###

# Tablica funkcji testowych
F = [(x -> 1.0 / (x^4 + x^2 + 0.9)),
     (x -> 1.0 / (1.0 + x^4)),
     (x -> 2.0 / (2.0 + sin(10.0 * pi * x))),
     (x -> cos(200.0 / (1.0 + x^2))),
     (x -> 1.0 / sqrt( 1.0 - x^2))]

# Tablica początków przedziałów całkowania (Zakładam, że A <= B)
A = [-1.0, 0.0, 0.0, -200.0, -0.9999]
# Tablica końców przedziałów całkowania
B = [1.0, 1.0, 1.0, 200.0, 0.9999]
# Epsilon używany do testów
ϵ = 1e-9
# Tablica dokładnych wyników całek (Liczone kwadraturą Gaussa-Konroda)
# quadgk to funkcja wbudowana Julii
I = Float64[]
for i = 1:5
  push!(I, quadgk(F[i], A[i], B[i])[1])
end

RombergEpsilon = Float64[]
for i = 1:5
  push!(RombergEpsilon, RombergsMethodEpsilon(A[i], B[i], F[i], 20, ϵ))
end

RombergK = Float64[]
for i = 1:5
  push!(RombergK, RombergsMethodK(A[i], B[i], F[i], 20))
end


println("-------------------------------------")
println("Wartości całek:\n",I)
println("-------------------------------------")

println("-------------------------------------")
println("Wartości całek obliczone metodą Romberga liczona \"do epsilona\"\n", RombergEpsilon)
println("-------------------------------------")

println("-------------------------------------")
println("Wartości całek obliczone metodą Romberga do K-tego poziomu\n", RombergK)
println("-------------------------------------")

println("-------------------------------------")
println("Tablica błędów dla pierwszej funkcji")
PrintErrorTable(F[1], A[1], B[1], 10, I[1])
println("-------------------------------------")

println("-------------------------------------")
println("Tablica błędów dla drugiej funkcji")
PrintErrorTable(F[2], A[2], B[2], 10, I[2])
println("-------------------------------------")

println("-------------------------------------")
println("Tablica błędów dla trzeciej funkcji")
PrintErrorTable(F[3], A[3], B[3], 10, I[3])
println("-------------------------------------")

println("-------------------------------------")
println("Tablica błędów dla czwartej funkcji")
PrintErrorTable(F[4], A[4], B[4], 10, I[4])
println("-------------------------------------")

println("-------------------------------------")
println("Tablica błędów dla piątej funkcji")
PrintErrorTable(F[5], A[5], B[5], 10, I[5])
println("-------------------------------------")

