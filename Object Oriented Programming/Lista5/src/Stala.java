public class Stala extends Wyrazenie
{
    int stala;
    public Stala(int stala)
    {
        this.stala = stala;
    }

    
    @Override
    public int oblicz()
    {
        return stala;
    }
    
    public String toString()
    {
        return Integer.toString(stala);
    }
    
    @Override
    public Wyrazenie pochodna()
    {
        return new Stala(0);
    }
}