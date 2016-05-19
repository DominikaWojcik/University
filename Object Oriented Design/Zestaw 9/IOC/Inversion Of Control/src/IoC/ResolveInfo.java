package IoC;

/**
 * Created by Dziku on 2016-05-19.
 */
public class ResolveInfo<T>
{
    boolean singleton;
    Class<T> type;
    T instance = null;

    public ResolveInfo(Class<T> type, boolean singleton)
    {
        this.singleton = singleton;
        this.type = type;
    }

    public T resolve() throws InstantiationException
    {
        if(singleton)
        {
            if(instance == null)
            {
                try
                {
                    instance = type.newInstance();
                }
                catch (InstantiationException | IllegalAccessException e)
                {
                    throw new InstantiationException("No default constructor");
                }
            }
            return instance;
        }

        try
        {
            return type.newInstance();
        }
        catch (InstantiationException | IllegalAccessException e)
        {
            throw new InstantiationException("No default constructor");
        }
    }
}
