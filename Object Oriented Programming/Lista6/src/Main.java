
import java.io.FileOutputStream;
import java.io.*;

/**
 *
 * @author Dziku
 */
public class Main {
    public static void main(String[] args)
    {
        ListaGeneryczna<Integer> lista = new ListaGeneryczna<>();
        for(int i=0;i<10;i++)lista.push_back(i);
        
        System.out.println(lista.size());
        for(int i=0;i<lista.size();i++)
        {
            System.out.println(lista.get(i));
        }
        
        FileOutputStream fileOut;
        ObjectOutputStream objOut;
        FileInputStream fileIn;
        ObjectInputStream objIn;
        try
        {
            fileOut = new FileOutputStream("lista.ser");
            objOut = new ObjectOutputStream(fileOut);
            objOut.writeObject(lista);
            objOut.close();
            fileOut.close();
            System.out.println("Zapisano dane w lista.ser");
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
        
        System.out.println("Próbujemy wczytać listę");
        lista=null;
        try
        {
            fileIn = new FileInputStream("lista.ser");
            objIn = new ObjectInputStream(fileIn);
            lista= (ListaGeneryczna<Integer>)objIn.readObject();
            objIn.close();
            fileIn.close();
            System.out.println("Wczytano dane z lista.ser");
        }
        catch(IOException e)
        {
            e.printStackTrace();
            return;
        }
        catch(ClassNotFoundException e)
        {
            System.out.println("Nie znaleziono niczego");
            e.printStackTrace();
            return;
        }
        System.out.println(lista.size());
        for(int i=0;i<lista.size();i++)
        {
            System.out.println(lista.get(i));
        }
        
    }
}
