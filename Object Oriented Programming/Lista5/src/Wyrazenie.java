public class Wyrazenie {
    Wyrazenie left,right;
    public Wyrazenie()
    {
        left=null;
        right=null;
    }
    public Wyrazenie(int x)
    {
        left=null;
        right=null;
    }
    public Wyrazenie(Wyrazenie left,Wyrazenie right)
    {
        this.left = left;
        this.right = right;
    }
    public int oblicz()
    {
        return left.oblicz() + right.oblicz();
    }
    public String toString()
    {
        return "";
    }
    
    public Wyrazenie pochodna()
    {
        return new Wyrazenie();
    }
    
    static Wyrazenie uprosc(Wyrazenie wyr)
    {
        if(wyr.left == null)return wyr;
        wyr.left = uprosc(wyr.left);
        wyr.right = uprosc(wyr.right);
        if(wyr instanceof Pomnoz && wyr.left instanceof Stala && wyr.left.oblicz()==1)
            return wyr.right;
        if(wyr instanceof Pomnoz && wyr.right instanceof Stala && wyr.right.oblicz()==1)
            return wyr.left;
        return wyr;
    }
}










