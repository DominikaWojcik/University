package com.lista8.State;

import java.util.ArrayList;

/**
 * Created by dziku on 12.05.16.
 */
public class TicketSelectionState extends TicketMachineState
{
    ArrayList<String> parameters;

    public TicketSelectionState(TicketMachine machine)
    {
        super(machine);
        parameters = new ArrayList<>();
    }

    @Override
    public void HandleInput(String input)
    {
        try
        {
            input = input.toLowerCase();
            if (input.equals("confirm"))
            {
                if (parameters.isEmpty()) throw new Exception("No parameters chosen!");

                System.out.println("Confirmed the ticket, moving to payment state");
                machine.SetState(new PaymentState(machine, parameters));
            }
            else if(input.equals("return"))
            {
                parameters.clear();
            }
            else
            {
                parameters.add(input);
                System.out.println("Przyjęto pamaretr " + input);
            }
        }
        catch (Exception e)
        {
            System.out.print(e.getMessage());
        }
    }

    @Override
    public void Initialize()
    {
        System.out.println("Initializing Ticket Selection State");
        System.out.println("Type your parameters here. Confirm your ticket with \"confirm\", discard the ticket with \"return\"");
    }

    @Override
    public void Cleanup()
    {
        System.out.println("Exiting Ticket Selection State");
    }
}
