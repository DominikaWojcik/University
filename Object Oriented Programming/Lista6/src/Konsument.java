/**
 *
 * @author Dziku
 */
public class Konsument extends Thread
{
    Bufor<Integer>bufor;
    
    Konsument(Bufor buf)
    {
        bufor=buf;
    }
    
    @Override
    public void run()
    {
        while(true)
        {
            try
            {
                int tmp=bufor.pop();
                System.out.println("Konsument wyciąga "+tmp);
            }
            catch(InterruptedException e)
            {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }
    }
}
