/**
 *
 * @author Dziku
 */

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

public class Pojazd implements Serializable
{
    public String marka, model,rocznik;
    
    public Pojazd()
    {
        marka=model=rocznik="";
    }
    public Pojazd(String marka, String model, int rocznik)
    {
        this.rocznik=Integer.toString(rocznik);
        this.marka=marka;
        this.model=model;
    }
    
    @Override
    public String toString()
    {
        return "Pojazd "+marka + " " + model + " rocznik " + rocznik;
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
            Pojazd tmp = (Pojazd)objIn.readObject();
            
            marka=tmp.marka;
            model=tmp.model;
            rocznik=tmp.rocznik;
            
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
