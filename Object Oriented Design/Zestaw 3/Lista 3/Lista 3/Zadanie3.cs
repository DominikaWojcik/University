using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_3
{
    class Zadanie3
    {
        public static void Main(string[] args)
        {

            Item[] items = new Item[]
            {
                new Item("Bułki", 2.00),
                new Item("Chleb", 3.00),
                new Item("Woda", 1.89),
                new Item("Sok", 4.29),
                new Item("Szynka", 8.34)
            };

            //PRZED ZMIANAMI
            Console.WriteLine("PRZED ZMIANAMI");
            
            CashRegister register = new CashRegister();
            Console.WriteLine("Sumaryczna cena wynosi {0}", register.CalculatePrice(items));
            register.PrintBill(items);

            Console.WriteLine("");
            //PO ZMIANACH
            Console.WriteLine("PO ZMIANACH");

            CashRegister2 improvedRegister = new CashRegister2();

            Console.WriteLine("Sumaryczna cena wynosi {0} przy podatku {1}", improvedRegister.CalculatePrice(items), improvedRegister.Tax);
            improvedRegister.Tax = new Decimal(0.33);
            Console.WriteLine("Sumaryczna cena wynosi {0} przy podatku {1}", improvedRegister.CalculatePrice(items), improvedRegister.Tax);

            Console.WriteLine("");
            Console.WriteLine("Paragon bez sortowania");
            improvedRegister.PrintBill(items, null);

            Console.WriteLine("");
            Console.WriteLine("Paragon posortowany alfabetycznie");
            improvedRegister.PrintBill(items, new AlphabeticalSorter());

            Console.WriteLine("");
            Console.WriteLine("Paragon posortowany cenowo");
            improvedRegister.PrintBill(items, new PriceSorter());
            
        }
    }


    public class TaxCalculator 
    {
        public static Decimal tax = new Decimal(0.22);
        public Decimal CalculateTax( Decimal Price ) { return Price * tax; }
    }
    public class Item 
    {
        Decimal _price;
        string _name;

        public Item(string name, Decimal price)
        {
            _price = price;
            _name = name;
        }

        public Item(string name, double price)
        {
            _price = new Decimal(price);
            _name = name;
        }

        public Decimal Price 
        { 
            get { return _price; }
            set { _price = value; }
        }
        public string Name 
        {
            get { return _name; } 
            set { _name = value; }
        }
    }
    public class CashRegister
    {
        public TaxCalculator taxCalc = new TaxCalculator();
        public Decimal CalculatePrice(Item[] Items)
        {
            Decimal _price = 0;
            foreach (Item item in Items)
            {
                _price += item.Price + taxCalc.CalculateTax(item.Price);
            }
            return _price;
        }

        public void PrintBill(Item[] Items)
        {
            foreach (var item in Items)
                Console.WriteLine("towar {0} : cena {1} + podatek {2}",
                    item.Name, item.Price, taxCalc.CalculateTax(item.Price));
        }
    }

    public class TaxCalculator2
    {
        private Decimal tax = new Decimal(0.22);

        public TaxCalculator2()
        {

        }

        public TaxCalculator2(double tax)
        {
            this.tax = new Decimal(tax);
        }

        public TaxCalculator2(Decimal tax)
        {
            this.tax = tax;
        }


        public Decimal Tax
        {
            get { return tax; }
            set { tax = value; }
        }

        public Decimal CalculateTax(Decimal Price) { return Price * tax; }
    }

    
    public class CashRegister2
    {
        public TaxCalculator2 taxCalc = new TaxCalculator2();

        public Decimal Tax
        {
            get { return taxCalc.Tax; }
            set { taxCalc.Tax = value; }
        }

        public Decimal CalculatePrice(Item[] Items)
        {
        
            Decimal _price = 0;
            foreach (Item item in Items)
            {
                _price += item.Price + taxCalc.CalculateTax(item.Price);
            }
            return _price;
        }

        public void PrintBill(Item[] Items, IItemSorter itemSorter)
        {
            Item[] sortedItems = Items;

            if(itemSorter != null)
            {
                itemSorter.SortItems(sortedItems);
            }

            Console.WriteLine("Wartość podatku {0}", Tax);
            foreach (var item in sortedItems)
                Console.WriteLine("towar {0} : cena {1} + podatek {2}",
                    item.Name, item.Price, taxCalc.CalculateTax(item.Price));

        }
    }

    public interface IItemSorter
    {
        Item[] SortItems(Item[] items);
    }

    public class AlphabeticalSorter : IItemSorter
    { 
        public Item[] SortItems(Item[] items)
        {
            int n = items.Length;
            for (int i = 1; i < n; i++)
            {
                for (int j = 1; j < n; j++)
                {
                    if (String.Compare(items[j - 1].Name, items[j].Name) > 0)
                    {
                        Item tmp = null;
                        tmp = items[j - 1];
                        items[j - 1] = items[j];
                        items[j] = tmp;
                    }
                }
            }

            return items;
        }
    }

    public class PriceSorter : IItemSorter
    {
        public Item[] SortItems(Item[] items)
        {
            int n = items.Length;
            for (int i = 1; i < n; i++)
            {
                for (int j = 1; j < n; j++)
                {
                    if (items[j-1].Price > items[j].Price)
                    {
                        Item tmp = null;
                        tmp = items[j - 1];
                        items[j - 1] = items[j];
                        items[j] = tmp;
                    }
                }
            }

            return items;
        }
    }
}
