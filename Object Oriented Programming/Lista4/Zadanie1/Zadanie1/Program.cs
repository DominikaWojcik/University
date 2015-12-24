using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Zadanie1
{
    interface Lista<T>
    {
        int Length
        {
            get;
        }
        T this[int i]
        {
            get;
        }

        void Add(T elem);
    }
    class LeniwaLista : Lista<int> , IEnumerable
    {
        protected int ile, licznik;
        protected List<int> lista;

        public LeniwaLista()
        {
            ile = 0;
            licznik = 1;
            lista = new List<int>();
            lista.Add(0);
        }

        public int Length
        {
            get { return ile; }
        }

        public int this[int i]
        {
            get
            {
                if (i <= ile) return lista[i];
                for (int j = ile + 1; j <= i; j++)
                {
                    lista.Add(licznik);
                    licznik++;
                }
                ile += i - ile;
                return lista[i];
            }

        }

        public void Add(int elem)
        {
            ile++;
            lista.Add(licznik);
            licznik++;
        }

        public override string ToString()
        {
            string tmp = "";
            for (int i = 1; i < Length; i++) tmp += lista[i].ToString() + " ";
            tmp += lista[Length].ToString();
            return tmp;
        }
        IEnumerator IEnumerable.GetEnumerator()
        {
            return (IEnumerator)GetEnumerator();
        }
        public LeniwaEnum GetEnumerator()
        {
            return new LeniwaEnum(lista);
        }

        public class LeniwaEnum : IEnumerator
        {
            int current;
            List<int> lista;
            public LeniwaEnum(List<int> lista)
            {
                current = 0;
                this.lista = lista;
            }
            public bool MoveNext()
            {
                current++;
                return (current < lista.Count) ;
            }
            object IEnumerator.Current
            {
                get { return Current; }
            }
            public int Current
            {
                get { return lista[current]; }
            }
            public void Reset()
            {
                current = 0;
            }
        }
    }

    public class ListaGeneryczna<T> : Lista<T>
    {
        public class Wezel
        {
            public Wezel prev, next;
            T val;
            public Wezel(T argument)
            {
                prev = next = null;
                val = argument;
            }
            public Wezel()
            {
                prev = next = null;
            }

            public T Value
            {
                get { return val; }
                set { val = value; }
            }

        }

        Wezel first, last;
        int count;

        public ListaGeneryczna()
        {
            count = 0;
            first = last = null;
        }

        public void push_front(T argument)
        {
            Wezel temp = new Wezel(argument);
            if (count > 0)
            {
                temp.next = first;
                first.prev = temp;
                first = temp;
            }
            else first = last = temp;
            count++;
        }

        public void push_back(T argument)
        {
            Wezel temp = new Wezel(argument);
            if (count > 0)
            {
                temp.prev = last;
                last.next = temp;
                last = temp;
            }
            else first = last = temp;
            count++;
        }

        public T pop_front()
        {
            //przy pustej liście powinno wyrzucić wyjątek
            T temp = first.Value;
            first = first.next;
            count--;
            return temp;
        }

        public T pop_back()
        {
            //przy pustej liscie powinno wyrzucic wyjatek
            T temp = last.Value;
            last = last.prev;
            count--;
            return temp;
        }
        public bool empty()
        {
            return count == 0;
        }

        public int Length
        {
            get { return count; }
        }

        public T this[int i] //iteruje od przodu
        {
            get
            {
                Wezel tmp = first;
                while (i > 0)
                {
                    tmp = tmp.next;
                    i--;
                }
                return tmp.Value;
            }
            set
            {
                Wezel tmp = first;
                while (i > 0)
                {
                    tmp = tmp.next;
                    i--;
                }
                tmp.Value = value;
            }
        }

        public void Add(T elem)
        {
            push_back(elem);
        }

        public override string ToString()
        {
            string tmp = "";
            for(int i=0;i<count-1;i++)
            {
                tmp += this[i].ToString() + " ";
            }
            if(count>0) tmp += this[count - 1].ToString();
            return tmp;
        }

       
    }
    class Program
    {
        static void Main(string[] args)
        {
            Lista<int> leniwa = new LeniwaLista();
            Lista<int> generyczna = new ListaGeneryczna<int>();

            Console.WriteLine(leniwa[46]);
            Console.WriteLine(leniwa.Length);
            Console.WriteLine(leniwa[32]);

            Console.WriteLine(generyczna.Length);
            generyczna.Add(4);
            generyczna.Add(5);
            Console.WriteLine(generyczna[1]);
            Console.WriteLine(generyczna.Length);

            foreach(int x in (LeniwaLista)leniwa)
            {
                Console.WriteLine(x);
            }
            Console.WriteLine(leniwa.ToString());

            while (true) { }
        }
    }
}
