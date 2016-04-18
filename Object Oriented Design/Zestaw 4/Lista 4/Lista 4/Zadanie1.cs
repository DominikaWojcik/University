using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace Lista_4
{
    class Zadanie1
    {
        /*static void Main(string[] args)
        {
        }*/
    }

    public class Singleton
    {
        private static Singleton instance;
        private static object lockObj = new Object();

        private Singleton()
        {
        }

        public static Singleton GetInstance()
        {
            lock(lockObj)
            {
                if(instance == null)
                {
                    instance = new Singleton();
                }
            }
            return instance;
        }
    }

    public class ThreadSingleton
    {
        private static ThreadLocal<ThreadSingleton> localInstance = new ThreadLocal<ThreadSingleton>();
        private ThreadSingleton()
        {
        }

        public static ThreadSingleton GetInstance()
        {
            if(localInstance.Value == null)
            {
                localInstance.Value = new ThreadSingleton();
            }
            return localInstance.Value;
        }
    }

    public class FiveSecondSingleton
    {
        private static FiveSecondSingleton instance;
        private static DateTime timer;
        private static object lockObj = new Object();
        private FiveSecondSingleton()
        {
        }

        public static FiveSecondSingleton GetInstance()
        {
            lock(lockObj)
            {
                if(instance == null)
                {
                    instance = new FiveSecondSingleton();
                    timer = DateTime.Now;
                }
                else 
                {
                    TimeSpan interval = DateTime.Now - timer;
                    if(interval.Seconds >= 5)
                    {
                        instance = new FiveSecondSingleton();
                        timer = DateTime.Now;
                    }
                }
            }
            return instance;
        }
    }
}
