
import java.util.Hashtable;


public class Zmienna extends Wyrazenie
{
    public static Hashtable<String,Integer> zmienne = new Hashtable<String,Integer>();
    String nazwa;
    public Zmienna(String nazwa)
    {
        this.nazwa=nazwa;
    }
    
    @Override
    public int oblicz()
    {
        return zmienne.get(nazwa);
    }
    
    public String toString()
    {
        return nazwa;
    }
    @Override
    public Wyrazenie pochodna()
    {
        return new Stala(1);
    }
}