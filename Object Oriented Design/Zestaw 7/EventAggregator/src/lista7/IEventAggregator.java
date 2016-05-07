package lista7;

/**
 * Created by Dziku on 2016-05-06.
 */
public interface IEventAggregator
{
    void AddSubscriber(String type, ISubscriber subscriber);
    void RemoveSubscriber(String type, ISubscriber subscriber);
    void Publish(String type, Object event);

}
