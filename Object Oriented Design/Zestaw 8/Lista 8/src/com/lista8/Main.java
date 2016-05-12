package com.lista8;

import com.lista8.Command.Invoker;
import com.lista8.State.TicketMachine;
import com.lista8.Strategy.DbDataAccessStrategy;
import com.lista8.Strategy.StrategyDataAccessHandler;
import com.lista8.Strategy.XmlDataAccessStrategy;
import com.lista8.Template.DataAccessHandler;
import com.lista8.Template.DbDataAccessHandler;
import com.lista8.Template.XmlDataAccessHandler;

public class Main
{
    public static void main(String[] args)
    {
        /*
        //ZADANIE 1
        System.out.println("\nZADANIE 1\n");

        Invoker invoker = new Invoker();
        System.out.println("Uruchamiam invoker");
        invoker.Run();
        */

        //ZADANIE 2
        System.out.println("\nZADANIE 2\n");

        DataAccessHandler xmlHandler = new XmlDataAccessHandler("ToParse.xml");
        //DataAccessHandler dbHandler = new DbDataAccessHandler();

        xmlHandler.Execute();
        //dbHandler.Execute();

        //ZADANIE 3
        System.out.println("\nZADANIE 3\n");

        StrategyDataAccessHandler xmlStrategyHandler = new StrategyDataAccessHandler(new XmlDataAccessStrategy("ToParse.xml"));
        //StrategyDataAccessHandler dbStrategyHandler = new StrategyDataAccessHandler(new DbDataAccessStrategy());

        xmlStrategyHandler.Execute();
        //dbStrategyHandler.Execute();

        //ZADANIE 4
        System.out.println("\nZADANIE 4\n");

        TicketMachine ticketMachine = new TicketMachine();
        ticketMachine.Run();
    }
}
