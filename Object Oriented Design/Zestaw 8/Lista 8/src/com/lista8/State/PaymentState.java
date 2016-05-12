package com.lista8.State;

import java.util.ArrayList;
import java.util.Random;

/**
 * Created by dziku on 12.05.16.
 */
public class PaymentState extends TicketMachineState
{
    private ArrayList<String> parameters;
    private float payment;

    public PaymentState(TicketMachine machine, ArrayList<String> parameters)
    {
        super(machine);
        this.parameters = parameters;
    }

    @Override
    public void HandleInput(String input)
    {
        input = input.toLowerCase();

        try
        {
            if(input.equals("card"))
            {
                System.out.println("Veryfing transacion");
                if(new Random().nextFloat() < 0.4) throw new Exception("Transaction rejected!");
                System.out.println("Transaction accepted");
                machine.SetState(new PrintTicketState(machine, parameters));
            }
            else if(input.equals("return"))
            {
                System.out.println("Canceling transaction");
                machine.SetState(new TicketSelectionState(machine));
            }
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
            machine.SetState(new TicketSelectionState(machine));
        }
    }

    @Override
    public void Initialize()
    {
        System.out.println("Initializing PaymentState");
        payment = 0;
        for(String param : parameters)
        {
            payment += 0.1 * param.length();
        }
        System.out.println("Total is $" + Float.toString(payment));

        System.out.println("Type \"card\" to begin transaction\nType \"return\" to cancel the ticket");
    }

    @Override
    public void Cleanup()
    {
        System.out.println("Exiting PaymentState");
    }
}
