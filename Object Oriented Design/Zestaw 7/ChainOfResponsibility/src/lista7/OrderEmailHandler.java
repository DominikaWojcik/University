package lista7;

/**
 * Created by Dziku on 2016-05-04.
 */
public class OrderEmailHandler extends EmailHandler
{
    @Override
    public void HandleEmail(Email email)
    {
        String content = email.GetContent();
        if(content.charAt(0) == 'o')
        {
            System.out.println("Mail z zamówieniem trafia do działu handlowego. Email: " + content);
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
