public class Odejmij extends Wyrazenie
{
    public Odejmij(Wyrazenie left,Wyrazenie right)
    {
        super(left, right);
    }
    
    @Override
    public int oblicz()
    {
        return left.oblicz() - right.oblicz();
    }
    public String toString()
    {
        return "("+left.toString()+" - "+right.toString()+")";
    }
    @Override
    public Wyrazenie pochodna()
    {
        Wyrazenie lt=left.pochodna(),rt=right.pochodna();
        if(lt instanceof Stala && rt instanceof Stala)
            return new Stala(lt.oblicz()-rt.oblicz());
        return new Odejmij(lt,rt);
    }
}