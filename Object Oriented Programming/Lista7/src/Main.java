import java.awt.Container;
import javax.swing.*;

public class Main 
{
    public static void main(String[] args)
    {
        Pojazd pojazd = new Pojazd();
        JPanel edycja = new JPanel();
        for(String s : args)System.out.println(s);
        switch(args[1])
        {
            case "Pojazd":
                pojazd = new Pojazd();
                pojazd.wczytaj(args[0]);
                edycja = new EdycjaPojazdu(pojazd,args[0]);
                break;
            case "Samochod":
                pojazd = new Samochod();
                pojazd.wczytaj(args[0]);
                edycja = new EdycjaSamochodu((Samochod)pojazd,args[0]);
                break;
            case "Tramwaj":
                pojazd= new Tramwaj();
                pojazd.wczytaj(args[0]);
                edycja = new EdycjaTramwaju((Tramwaj)pojazd,args[0]);
                break;
            default:
                System.out.println("Nie ma takiej opcji");
                break;
        }
        System.out.println(pojazd);
        
        JFrame frame;
        frame = new JFrame("Program");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        Container kontener = frame.getContentPane();
        
        kontener.add(edycja);
        frame.pack();
        frame.setVisible(true);
        
    }
}
