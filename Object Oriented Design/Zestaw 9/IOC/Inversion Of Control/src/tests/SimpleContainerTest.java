package tests;

import IoC.*;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;


/**
 * Created by Dziku on 2016-05-19.
 */
public class SimpleContainerTest
{
    @Rule
    public ExpectedException thrown = ExpectedException.none();

    @Test
    public void ResolveNotRegisteredType() throws InstantiationException
    {
        SimpleContainer c = new SimpleContainer();

        thrown.expect(InstantiationException.class);

        c.resolve(IFoo.class);
    }

    @Test
    public void ResolveSingletons() throws InstantiationException
    {
        SimpleContainer c = new SimpleContainer();

        c.registerType(IFoo.class, Foo.class, true);

        IFoo a = c.resolve(IFoo.class);
        IFoo b = c.resolve(IFoo.class);

        Assert.assertSame(a, b);
    }

    @Test
    public void ChangeRegisteredType() throws InstantiationException
    {
        SimpleContainer c = new SimpleContainer();

        c.registerType(IFoo.class, Foo.class, false);
        IFoo a = c.resolve(IFoo.class);

        c.registerType(IFoo.class, Bar.class, false);
        IFoo b = c.resolve(IFoo.class);

        Assert.assertEquals(a.getClass(), Foo.class);
        Assert.assertEquals(b.getClass(), Bar.class);

        Assert.assertNotSame(a.getClass(), b.getClass());
    }

    @Test
    public void ResolveTypeWithoutDefaultConstructor() throws InstantiationException
    {
        SimpleContainer c = new SimpleContainer();

        c.registerType(IFoo.class, Qux.class, false);

        thrown.expect(InstantiationException.class);
        thrown.expectMessage("No default constructor");

        IFoo a = c.resolve(IFoo.class);
    }
}