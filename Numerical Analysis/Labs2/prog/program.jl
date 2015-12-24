#=
Autor: Jarosław Dzikowski 273233
Zadanie 2.9: Wskaźnik uwarunkowania interpolacji Lagrange'a

=#

# Funkcja wylicza wartość k-tej lambdy w punkcie x dla zadanych węzłów interpolacji nodes
function λ(nodes, k::Int, x::Float64)
  out = 1.0
  for i=1:length(nodes)
    if i == k
      continue
    end
    out = out*(x - nodes[i])/(nodes[k] - nodes[i])
  end
  return out
end

# Wylicza wartość wielomianu interpolacyjnego dla zadanych węzłów i funkcji w punkcie x
function lagrangeInterpolation(nodes, func, x::Float64)
  sum = 0.0
  for i = 1:length(nodes)
    sum = sum + func(nodes[i]) * λ(nodes, i, x)
  end
  return sum
end

# Wylicza wartość funkcji Lebesgue'a w punkcie x dla zadanych węzłów
function lebesgueFunction(nodes, x::Float64)
  sum::Float64 = 0.0
  for i = 1:length(nodes)
    sum = sum + abs(λ(nodes, i, x))
  end
  return sum
end

# Wylicza stałą Lebesgue'a dla zadanych węzłów poprzez sprawdzenie funkcji Lebesgue'a w density miejscach i wybraniu maksimum
function Λ(nodes, density::Int)
  out::Float64 = 0.0
  interval::Float64 = 2.0/density
  for i = 0:density
    x = interval * i - 1.0
    out = max(out, lebesgueFunction(nodes, x))
  end
  return out
end

# Poniższe funkcje zwracają zestaw n węzłów o różnych charakterystykach
function equidistantNodes(n::Int)
  nodes = Float64[]
  interval = 2.0/(n-1)
  for i=0:n-1
    push!(nodes, interval * i - 1.0)
  end
  return nodes
end

function chebyshevNodes(n::Int)
  nodes = Float64[]
  for i=1:n
    push!(nodes, cos((pi/2.0)*((2*i - 1)/n)))
  end
  return nodes
end

function extendedChebyshevNodes(n::Int)
  α = cos(pi/(2.0*n) )
  nodes = chebyshevNodes(n)
  for i=1:length(nodes)
    nodes[i]=nodes[i]/α
  end
  return nodes
end

function randomNodes(n::Int)
  nodes = Float64[]
  for i = 1:n
    repeat = true
    x = 2.0*rand() -1.0

    while repeat == true
      repeat = false
      x = x = 2.0*rand() -1.0
      for j = 1:length(nodes)
        if x == nodes[j]
          repeat = true
          break
        end
      end
    end
    push!(nodes, x)
  end
  return nodes
end

# Trzy funkcje, które będą interpolowane
function first(x)
  return 1.0/(1.0 + 25.0*x*x)
end

function second(x)
  return atan(x)
end

function third(x)
  return max(0.0, 1.0 - 4.0*x)
end

# Funkcje, które wypisują do pliku name wartości funkcji w różnych punktach. Dane te potem można konwertować przez gnuplot do wykresu
function plotInterpError(name, nodes, func, points)
  file = open(name, "w")
  write(file, "# X Y\n")

  interval::Float64 = 2.0/(points - 1)

  for i=0:points-1
    x = i*interval -1.0
    write(file, string(x)," ",string(abs(func(x) - lagrangeInterpolation(nodes, func, x))),"\n")
  end

  close(file)
end

function plotLebesgueFunction(name, nodes, points)
  file = open(name, "w")
  write(file, "# X Y\n")

  interval::Float64 = 2.0/(points - 1)

  for i=0:points-1
    x = i*interval -1.0
    write(file, string(x)," ",string(lebesgueFunction(nodes, x)),"\n")
  end

  close(file)
end

function plotLebesgueConstant(name, nodesFunc, rangeStart, rangeEnd, points)
  file = open(name, "w")
  write(file, "# X Y\n")

  for i = rangeStart:rangeEnd
    write(file, string(i), " ", string(Λ(nodesFunc(i), points)),"\n")
  end

  close(file)
end

# Właściwa część programu. Dobieramy liczbę węzłów, punkty kontrolne.

nodesNumber = 9
checkPoints = 1000

# Konstruujemy węzły
equiNodes = equidistantNodes(nodesNumber)
cheNodes = chebyshevNodes(nodesNumber)
extNodes = extendedChebyshevNodes(nodesNumber)
#randNodes = randomNodes(nodesNumber)
randNodes = [-0.7453989105979439,0.09659569701458537,0.7284483724043662,-0.383637844421969,-0.2182794370328942,0.8391178947234881,-0.8658512898743727,0.8816553002859595,0.562708785951151]

# Tworzymy wykresy
#=
plotInterpError("firstEqui.dat", equiNodes, first, checkPoints)
plotInterpError("firstChe.dat", cheNodes, first, checkPoints)
plotInterpError("firstExt.dat", extNodes, first, checkPoints)
plotInterpError("firstRand.dat", randNodes, first, checkPoints)

plotInterpError("secondEqui.dat", equiNodes, second, checkPoints)
plotInterpError("secondChe.dat", cheNodes, second, checkPoints)
plotInterpError("secondExt.dat", extNodes, second, checkPoints)
plotInterpError("secondRand.dat", randNodes, second, checkPoints)

plotInterpError("thirdEqui.dat", equiNodes, third, checkPoints)
plotInterpError("thirdChe.dat", cheNodes, third, checkPoints)
plotInterpError("thirdExt.dat", extNodes, third, checkPoints)
plotInterpError("thirdRand.dat", randNodes, third, checkPoints)

plotLebesgueFunction("lebesgueEqui.dat", equiNodes, checkPoints)
plotLebesgueFunction("lebesgueChe.dat", cheNodes, checkPoints)
plotLebesgueFunction("lebesgueExt.dat", extNodes, checkPoints)
plotLebesgueFunction("lebesgueRand.dat", randNodes, checkPoints)

plotLebesgueConstant("constantEqui.dat", equidistantNodes, 5, 20, checkPoints)
plotLebesgueConstant("constantChe.dat", chebyshevNodes, 5, 100, checkPoints)
plotLebesgueConstant("constantExt.dat", extendedChebyshevNodes, 5, 100, checkPoints)
plotLebesgueConstant("constantRand.dat", randomNodes, 5, 12, checkPoints)
=#

# Wypisujemy stałe Lebesgue'a dla różnych węzłów
println("Liczba węzłów: ",nodesNumber)
println("Węzły równoodległe - Λ = ", Λ(equiNodes, checkPoints))
println("Węzły Czybyszewa - Λ = ", Λ(cheNodes, checkPoints))
println("Rozszerzone węzły Czybyszewa - Λ = ", Λ(extNodes, checkPoints))
println("Losowe węzły - Λ = ", Λ(randNodes, checkPoints))



