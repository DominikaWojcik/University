/**
 *
 * @author Dziku
 */
public class Producent extends Thread
{
    Bufor<Integer>bufor;
    
    Producent(Bufor<Integer> buf)
    {
        bufor=buf;
    }
    @Override
    public void run()
    {
        int licznik=1;
        while(licznik>0)
        {
            try
            {
                System.out.println("Producent wyprodukował "+licznik);
                bufor.push(licznik);
                licznik++;
            }
            catch(InterruptedException e)
            {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }
    }
}
