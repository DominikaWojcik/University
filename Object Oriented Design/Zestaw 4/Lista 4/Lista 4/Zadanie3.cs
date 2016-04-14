using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_4
{
    class Zadanie3
    {
    }

    public class Airport
    {
        private const int DEFAULT_CAPACITY = 100;

        private static Airport instance;
        private static object instanceLock = new Object();

        private List<Plane> free, inUse;
        private object listLock = new Object();

        private Airport()
        {
            free = new List<Plane>();
            inUse = new List<Plane>();

            for(int i = 0; i < DEFAULT_CAPACITY; i++)
            {
                free.Add(new Plane(){Id = i});
            }
        }

        public Plane AcquirePlane()
        {
            lock(listLock)
            {
                //Nie możemy dorobić nowego samolotu
                if(free.Count == 0)
                {
                    throw new Exception("No free planes remaining.");
                }
                
                Plane acquired = free[free.Count - 1];
                free.RemoveAt(free.Count - 1);
                inUse.Add(acquired);

                return acquired;
            }
        }

        public void ReleasePlane(Plane plane)   
        {
            lock (listLock)
            {
                free.Add(plane);
                inUse.Remove(plane);
            }
        }

        public static Airport Instance()
        {
            lock(instanceLock)
            {
                if(instance == null)
                {
                    instance = new Airport();
                }
            }
            return instance;
        }

    }

    public class Plane
    {
        public int Id { get; set; }
    }
}
