public class Podziel extends Wyrazenie
{
    public Podziel(Wyrazenie left, Wyrazenie right)
    {
        super(left,right);
    }
    
    @Override
    public int oblicz()
    {
        int mianownik=right.oblicz();
        if(mianownik==0) throw new ArithmeticException("Dzielenie przez zero");
        return left.oblicz()/mianownik; 
    }
    
    public String toString()
    {
        return "("+left.toString()+" / "+right.toString()+")";
    }
    
    @Override
    public Wyrazenie pochodna()
    {
        return new Podziel(new Odejmij(new Pomnoz(left.pochodna(),right),
                new Pomnoz(left,right.pochodna())),new Pomnoz(right,right));
    }
}