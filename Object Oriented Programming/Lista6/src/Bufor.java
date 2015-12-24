/**
 *
 * @author Dziku
 */
public class Bufor<T> 
{
    Box<T>[] tab;
    int size,front,back,howmany;
    private class Box<T>
    {
        T elem;
        Box(T elem)
        {
            this.elem = elem;
        }
    }
    public Bufor(int size)
    {
        this.howmany=0;
        this.front=0;
        this.back=0;
        this.size=size;
        this.tab= new Box[size];
    }
    
    public synchronized void push(T what) throws InterruptedException
    {
        while(howmany==size)wait();
        //System.out.println("Buf back = "+back);
        tab[back]= new Box(what);
        back=(back+1)%size;
        howmany++;
        notify();
    }
    
    public synchronized T pop() throws InterruptedException
    {
        while(howmany==0)wait();
        howmany--;
        T tmp=tab[front].elem;
        front=(front+1)%size;
        notify();
        return tmp;
    }
}
