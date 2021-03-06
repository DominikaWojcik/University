using System;

namespace ListaGeneryczna
{
	public class Lista<T>
	{
        public class Wezel
        {
            public Wezel prev,next;
            T value;
            public Wezel(T argument)
            {
                prev = next = null;
                value = argument;
            }
            public Wezel()
            {
                prev = next = null;
            }

            public T getValue()
            {
                return value;
            }

        }
		
        Wezel first, last;
		int count;

		public Lista()
		{
			count = 0;
			first = last = null;
		}

		public void push_front(T argument)
		{
			Wezel temp = new Wezel(argument);
			if(count>0)
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
			T temp = first.getValue();
			first = first.next;
			count--;
			return temp;
		}

		public T pop_back()
		{
			//przy pustej liscie powinno wyrzucic wyjatek
			T temp = last.getValue();
			last = last.prev;
			count--;
			return temp;
		}
		public bool empty()
		{
			return count == 0;
		}

		public int size()
		{
			return count;
		}
	}
}


