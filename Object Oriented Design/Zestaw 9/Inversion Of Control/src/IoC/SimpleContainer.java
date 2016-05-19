package IoC;

import java.util.HashMap;

/**
 * Created by Dziku on 2016-05-19.
 */
public class SimpleContainer
{
    private HashMap<Class, ResolveInfo> registeredTypes;

    public SimpleContainer()
    {
        registeredTypes = new HashMap<>();
    }

    public <T> void registerType(Class<T> type, boolean singleton)
    {
        registeredTypes.put(type, new ResolveInfo(type, singleton));
    }

    public <T,S> void registerType(Class<T> typeIn, Class<S> typeOut, boolean singleton)
    {
        registeredTypes.put(typeIn, new ResolveInfo(typeOut, singleton));
    }

    public <T> T resolve(Class<T> type) throws InstantiationException
    {
        if(!registeredTypes.containsKey(type))
        {
            throw new InstantiationException("No class " + type.toString() + " registered");
        }

        return (T)registeredTypes.get(type).resolve();
    }
}
