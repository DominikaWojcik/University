/**
 *
 * @author Dziku
 */
import java.io.Serializable;


public class ListaGeneryczna <T> implements Serializable 
{
    Wezel first,last;
    int ile;
    
    private class Wezel implements Serializable
    {
        Wezel next,prev;
        T value;
        
        Wezel(T value)
        {
            this.value=value;
            next=null;
            prev=null;
        }
    }
    
    public ListaGeneryczna()
    {
        first=last=null;
        ile=0;
    }    
    
    public int size()
    {
        return ile;
    }
    
    public void push_back(T elem)
    {
        if(last==null)
            first=last=new Wezel(elem);
        else
        {
            last.next=new Wezel(elem);
            last.next.prev=last;
            last=last.next;
        }
        ile++;
    }
    public void push_front(T elem)
    {
        if(first==null)
            first=last=new Wezel(elem);
        else
        {
            first.prev=new Wezel(elem);
            first.prev.next=first;
            first=first.prev;
        }
        ile++;
    }
    
    public T pop_back() throws IndexOutOfBoundsException
    {
        if(ile==0) throw new IndexOutOfBoundsException("Lista jest już pusta!");
        T tmp=last.value;
        last=last.prev;
        if(last!=null)last.next=null;
        return tmp;
    }
    
    public T pop_front() throws IndexOutOfBoundsException
    {
        if(ile==0) throw new IndexOutOfBoundsException("Lista jest już pusta!");
        T tmp=first.value;
        first=first.next;
        if(first!=null)first.prev=null;
        return tmp;
    }
    
    public T get(int index) throws IndexOutOfBoundsException
    {
        if(index>=ile || index <0)throw new IndexOutOfBoundsException("Nie ma takiego elementu!");
        Wezel tmp=first;
        while(index>0)
        {
            index--;
            tmp=tmp.next;
        }
        return tmp.value;
    }
}

