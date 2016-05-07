//package lista7;

/**
 * Created by Dziku on 2016-05-04.
 */
public class PraiseEmailHandler extends EmailHandler
{
    public void HandleEmail(Email email)
    {
        String content = email.GetContent();
        if(content.charAt(0) == 'p')
        {
            System.out.println("Mail z pochwałą trafia do prezesa. Email: " + content);
        }
        else if(next != null)
        {
            next.HandleEmail(email);
        }
        else
        {
            System.out.println("Mail trafił do działu marketingu. Email: " + content);
        }
    }
}
