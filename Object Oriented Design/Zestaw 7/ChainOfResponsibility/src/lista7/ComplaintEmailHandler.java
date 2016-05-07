//package lista7;

/**
 * Created by Dziku on 2016-05-04.
 */
public class ComplaintEmailHandler extends EmailHandler
{
    public void HandleEmail(Email email)
    {
        String content = email.GetContent();
        if(content.charAt(0) == 'c')
        {
            System.out.println("Mail ze skargą trafia do działu prawnego. Email: " + content);
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
