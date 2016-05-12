package com.lista8.State;

import java.util.ArrayList;

/**
 * Created by dziku on 12.05.16.
 */
public class PrintTicketState extends TicketMachineState
{
    private ArrayList<String> parameters;

    public PrintTicketState(TicketMachine machine, ArrayList<String> parameters)
    {
        super(machine);
        this.parameters = parameters;
    }

    @Override
    public void HandleInput(String input)
    {
        input = input.toLowerCase();
        if(input.equals("yes"))
        {
            machine.SetState(new PrintConfirmationState(machine, parameters));
        }
        else if(input.equals("no"))
        {
            machine.SetState(new IdleState(machine));
        }
    }

    @Override
    public void Initialize()
    {
        System.out.println("Initializing PrintTicketState");
        System.out.println("Setting up printing machine...");
        System.out.println("Printing your ticket...");

        System.out.print("Your ticket: ");
        for(int i=0;i<parameters.size();i++)
        {
            System.out.print(parameters.get(i) + " ");
        }
        System.out.print("\n");

        System.out.println("Do you want to print purchase confirmation? (yes/no)");
    }

    @Override
    public void Cleanup()
    {
        System.out.println("Exiting PrintTicketState");
    }


}
