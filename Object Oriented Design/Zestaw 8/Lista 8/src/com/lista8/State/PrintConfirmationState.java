package com.lista8.State;

import java.util.ArrayList;

/**
 * Created by dziku on 12.05.16.
 */
public class PrintConfirmationState extends TicketMachineState
{
    private ArrayList<String> parameters;

    public PrintConfirmationState(TicketMachine machine, ArrayList<String> parameters)
    {
        super(machine);
        this.parameters = parameters;
    }

    @Override
    public void HandleInput(String input)
    {

    }

    @Override
    public void Initialize()
    {
        System.out.println("Initializing PrintConfirmationState");
        System.out.println("Setting up printing machine...");
        System.out.println("Printing...");
        System.out.println("Confirmation: " + parameters.toString());
        System.out.println("Confirmation printed");

        machine.SetState(new IdleState(machine));
    }

    @Override
    public void Cleanup()
    {
        System.out.println("Exiting PrintConfirmationState");
    }
}
