using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_7
{
    public interface ISubscriber<T>
    {
        void HandleNotification(T Notification);
    }

    public interface IEventAggregator
    {
        void AddSubscriber<T>(ISubscriber<T> Subscriber);
        void RemoveSubscriber<T>(ISubscriber<T> Subscriber);
        void Publish<T>(T Event);
    }

    public class EventAggregator : IEventAggregator
    {
        private static EventAggregator instance;

        private Dictionary<Type, List<object>> subscribers;

        private EventAggregator()
        {
            subscribers = new Dictionary<Type, List<object>>();
        }

        public static EventAggregator Instance
        {
            get
            {
                if(instance == null)
                {
                    instance = new EventAggregator();
                }
                return instance;
            }
        }

        #region IEventAggregator Members
        
        public void AddSubscriber<T>(ISubscriber<T> Subscriber)
        {
            if(!subscribers.ContainsKey(typeof(T)))
            {
                subscribers.Add(typeof(T), new List<object>());
            }
            subscribers[typeof(T)].Add(Subscriber);
        }

        public void RemoveSubscriber<T>(ISubscriber<T> Subscriber)
        {
            if(subscribers.ContainsKey(typeof(T)))
            {
                subscribers[typeof(T)].Remove(Subscriber);
            }
        }

        public void Publish<T>(T Event)
        {
            if(subscribers.ContainsKey(typeof(T)))
            {
                foreach(ISubscriber<T> subscriber 
                    in subscribers[typeof(T)].OfType<ISubscriber<T>>())
                {
                    subscriber.HandleNotification(Event);
                }
            }
        }

        #endregion
    }

}
