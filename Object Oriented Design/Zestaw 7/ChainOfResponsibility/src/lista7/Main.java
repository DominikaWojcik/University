package lista7;

import javafx.util.Pair;

import java.util.ArrayList;
import java.util.Date;

public class Main {

    public static void main(String[] args)
    {
        ArrayList<Pair<Date, Email>> history = new ArrayList<>();

        EmailHandler h1 = new ArchiverEmailHandler(history);
        h1.SetNext(new PraiseEmailHandler());
        h1.SetNext(new ComplaintEmailHandler());
        h1.SetNext(new OrderEmailHandler());

        Email praise = new Email("p Good job!");
        Email complaint = new Email("c I am upset!");
        Email order = new Email("o Order something");
        Email misc = new Email("m Anything else");

        h1.HandleEmail(praise);
        h1.HandleEmail(complaint);
        h1.HandleEmail(order);
        h1.HandleEmail(misc);

        System.out.println("Historia emaili:");
        for (Pair<Date, Email> p : history)
        {
            System.out.println(p.getKey().toString() + " : " + p.getValue().GetContent());
        }
    }
}
