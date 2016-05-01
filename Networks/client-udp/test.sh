NR=1

function CompareOutput
{
	DIFF=$(diff $1 $2)
	if [ "$DIFF" != "" ]
	then
		echo $DIFF
	else
		echo $1 "i" $2 "są takie same"
	fi
}

function Test
{
	echo "TEST" $NR
	NR++
	echo "Porównanie z" $1 "wczytujemy" $2 "bajtów"
	echo "Mój klient:"
	time ./client-udp 40002 output $2 > moj.log
	echo ""
	echo $1 ":"
	time ./$1 40002 output2 $2 > zad1wz.log
	echo ""
	echo "Sprawdzenie diffem:"
	CompareOutput output output2
	rm output output2
}


echo "PRACOWNIA SIECI KOMPUTEROWE ZADANIE 3"
echo ""

echo "KOMPILACJA"
echo "Czyszczenie:"
make distclean
echo "Budowanie"
make

echo ""
echo "TEST 1"
echo "Porównanie z client-udp-slower-64, wczytujemy 3237 bajtów"
echo "Mój klient:"
time ./client-udp 40002 output 3237 > zad1moj.log
echo ""
echo "client-udp-slower-64:"
time ./client-udp-slower-64 40002 output2 3237 > zad1wz.log
echo ""
echo "Sprawdzenie diffem:"
CompareOutput output output2

echo ""
echo "TEST 2"
echo "Porównanie z client-udp-slower-64, wczytujemy 15892 bajtów"
echo "Mój klient:"
time ./client-udp 40002 output 15892 > zad2moj.log
echo ""
echo "client-udp-slower-64:"
time ./client-udp-slower-64 40002 output2 15892 > zad2wz.log
echo ""
echo "Sprawdzenie diffem:"
CompareOutput output output2

echo ""
echo "TEST 3"
echo "Porównanie z client-udp-faster-64, wczytujemy 52452 bajtów"
echo "Mój klient:"
time ./client-udp 40002 output 52452 > zad3moj.log
echo ""
echo "client-udp-faster-64:"
time ./client-udp-faster-64 40002 output2 52452 > zad3wz.log
echo ""
echo "Sprawdzenie diffem:"
CompareOutput output output2

echo ""
echo "TEST 4"
echo "Porównanie z client-udp-faster-64, wczytujemy 932897 bajtów"
echo "Mój klient:"
time ./client-udp 40002 output 932897 > zad3moj.log
echo ""
echo "client-udp-faster-64:"
time ./client-udp-faster-64 40002 output2 932897 > zad3wz.log
echo ""
echo "Sprawdzenie diffem:"
CompareOutput output output2

Test client-udp-faster-64 13337
Test client-udp-slower-64 1337
Test client-udp-slower-64 13337

echo ""
echo "CZYSZCZENIE"
rm output output2

