//package lista7;

/**
 * Created by Dziku on 2016-05-04.
 */
public abstract class EmailHandler
{
    protected EmailHandler next;

    public void SetNext(EmailHandler next)
    {
        if(this.next == null)
        {
            this.next = next;
        }
        else this.next.SetNext(next);
    }

    public abstract void HandleEmail(Email email);
}
