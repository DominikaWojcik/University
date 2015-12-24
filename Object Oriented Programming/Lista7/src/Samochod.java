
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;


/**
 *
 * @author Dziku
 */
public class Samochod extends Pojazd
{
    String kolor;
    
    public Samochod()
    {
        super();
        kolor="";
    }
    
    public Samochod(String marka, String model, int rocznik,String kolor)
    {
        super(marka,model,rocznik);
        this.kolor=kolor;
    }
    
    @Override
    public String toString()
    {
        return kolor+" samochod "+marka+" "+model+" rocznik "+rocznik;
    }
    
    public void zapisz(String nazwa)
    {
        FileOutputStream fileOut;
        ObjectOutputStream objOut;

        try
        {
            fileOut = new FileOutputStream(nazwa);
            objOut = new ObjectOutputStream(fileOut);
            objOut.writeObject(this);
            objOut.close();
            fileOut.close();
            System.out.println("Zapisano dane w "+nazwa);
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
    }
    
    public void wczytaj(String nazwa)
    {
        FileInputStream fileIn;
        ObjectInputStream objIn;
        
        File f = new File(nazwa);
        if(f.exists())
        try
        {
            fileIn = new FileInputStream(f);
            objIn = new ObjectInputStream(fileIn);
            Samochod tmp = (Samochod)objIn.readObject();
            
            marka=tmp.marka;
            model=tmp.model;
            rocznik=tmp.rocznik;
            kolor=tmp.kolor;
            
            objIn.close();
            fileIn.close();
            System.out.println("Wczytano dane z "+nazwa);
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
        catch(ClassNotFoundException e)
        {
            System.out.println("Nie znaleziono niczego");
            e.printStackTrace();
        }
        
        else System.out.println("Plik "+nazwa +" jeszcze nie istnieje");
    }
}
