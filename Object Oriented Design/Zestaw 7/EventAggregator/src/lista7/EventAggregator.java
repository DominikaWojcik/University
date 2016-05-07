package lista7;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Dziku on 2016-05-06.
 */
public class EventAggregator implements IEventAggregator
{
    private static EventAggregator instance;

    private HashMap<String, ArrayList<ISubscriber>> subscribers;

    private EventAggregator()
    {
        subscribers = new HashMap<>();
    }

    public static EventAggregator Instance()
    {
        if(instance == null)
        {
            instance = new EventAggregator();
        }
        return instance;
    }

    @Override
    public void AddSubscriber(String type, ISubscriber subscriber)
    {
        if(!subscribers.containsKey(type))
        {
            subscribers.put(type, new ArrayList<>());
        }
        subscribers.get(type).add(subscriber);
    }

    @Override
    public void RemoveSubscriber(String type, ISubscriber subscriber)
    {
        if(subscribers.containsKey(type))
        {
            subscribers.get(type).remove(subscriber);
        }
    }

    @Override
    public void Publish(String type, Object event)
    {
        if(subscribers.containsKey(type))
        {
            for(ISubscriber subscriber : subscribers.get(type))
            {
                subscriber.HandleNotification(event);
            }
        }
    }
}
