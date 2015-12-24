public class Pomnoz extends Wyrazenie
{
    public Pomnoz(Wyrazenie left, Wyrazenie right)
    {
        super(left,right);
    }
    @Override
    public int oblicz()
    {
        return left.oblicz()*right.oblicz();
    }
    public String toString()
    {
        return "("+left.toString()+" * "+right.toString()+")";
    }
    
    @Override
    public Wyrazenie pochodna()
    {
        /*Wyrazenie lt=left.pochodna(),rt=right.pochodna();
        if(lt instanceof Stala && right instanceof Stala)
        {
            if(rt instanceof Stala && left instanceof Stala)
                return new Stala(lt.oblicz()*right.oblicz()+left.oblicz()*rt.oblicz());
            else return new Dodaj(new Stala(lt.oblicz()*right.oblicz()),new Pomnoz(left,rt));
        }
        if(rt instanceof Stala && left instanceof Stala)
        {
            if(lt instanceof Stala && right instanceof Stala)
                return new Stala(lt.oblicz()*right.oblicz()+left.oblicz()*rt.oblicz());
            else return new Dodaj(new Pomnoz(lt,right),new Stala(left.oblicz()*rt.oblicz()));
        }*/
        return new Dodaj(new Pomnoz(left.pochodna(),right),new Pomnoz(left,right.pochodna()));
    }
}