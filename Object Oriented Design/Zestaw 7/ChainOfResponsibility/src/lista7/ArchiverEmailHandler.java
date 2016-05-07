//package lista7;

//import javafx.util.Pair;

import java.util.Map;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by Dziku on 2016-05-04.
 */
public class ArchiverEmailHandler extends EmailHandler
{
    //private ArrayList<Pair<Date, Email>> history;
	private ArrayList<Map.Entry<Date, Email>> history;

    //public ArchiverEmailHandler(ArrayList<Pair<Date, Email>> history)
    public ArchiverEmailHandler(ArrayList<Map.Entry<Date, Email>> history)
    {
        this.history = history;
    }

    @Override
    public void HandleEmail(Email email)
    {
        //history.add(new Pair<>(new Date(), email));
        //history.add(new Map.Entry<>(new Date(), email));
        history.add(new AbstractMap.SimpleEntry<>(new Date(), email));
        if(next != null)
        {
            next.HandleEmail(email);
        }
    }
}
