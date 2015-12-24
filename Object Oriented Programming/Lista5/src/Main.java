
public class Main {
    
    
    
    public static void main(String[] args)
    {
        Zmienna.zmienne.put("x",3);
        Zmienna.zmienne.put("y",7);
        Wyrazenie a = new Pomnoz(new Dodaj(new Stala(4),new Stala(7)),new Odejmij(new Zmienna("x"),new Zmienna("x")));
        System.out.println(a);
        System.out.println(a.oblicz());
        System.out.println(a.pochodna());
        //Wyrażenie b to (x^2 + x^3)
        Wyrazenie b = new Dodaj(new Pomnoz(new Zmienna("x"),new Zmienna("x")),new Pomnoz(new Pomnoz(new Zmienna("x"),new Zmienna("x")),new Zmienna("x")));
        System.out.println(b);
        System.out.println(b.pochodna());
        System.out.println(Wyrazenie.uprosc(b.pochodna()));
        
    }
}
