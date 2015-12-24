using System;
using ListaGeneryczna;

public class MainClass
{
	public static void Main(string[] args)
	{
		Lista<int> list = new Lista<int> ();
        bool done = false;

        Console.WriteLine("Program demonstrujący możliwości listy");
        Console.WriteLine("1 i - Dodaj liczbę i na poczatek listy");
        Console.WriteLine("2 i - Dodaj liczbę i na koniec listy");
        Console.WriteLine("3 - Usuń i wypisz pierwszy element listy");
        Console.WriteLine("4 - Usuń i wypisz ostatni element listy");
        Console.WriteLine("5 - Wypisz aktualny rozmiar listy");
        Console.WriteLine("6 - Sprawdz, czy lista jest pusta");
        Console.WriteLine("Cokolwiek innego zakończy działanie programu");
		while (!done)
		{
			string[] input = Console.ReadLine().Split();
			switch(int.Parse(input[0]))
			{
				case 1:
					list.push_front(int.Parse(input[1]));
					break;
				case 2:
					list.push_back(int.Parse(input[1]));
					break;
				case 3:
					Console.WriteLine("Wyrzucono z przodu {0}", list.pop_front());
					break;
				case 4:
					Console.WriteLine("Wyrzucono z tyłu {0}", list.pop_back());
					break;
                case 5:
                    Console.WriteLine("Rozmiar listy to {0}", list.size());
                    break;
                case 6:
                    Console.WriteLine("{0}", list.empty() ? "Lista pusta" : "Lista nie jest pusta");
                    break;
                default:
                    done = true;
                    break;
			}
		}
	}
}
