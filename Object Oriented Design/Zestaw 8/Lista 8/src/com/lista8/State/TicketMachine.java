package com.lista8.State;

import java.io.InputStream;
import java.util.Scanner;

/**
 * Created by dziku on 12.05.16.
 */
public class TicketMachine
{
    private TicketMachineState state;

    public TicketMachine()
    {
        SetState(new IdleState(this));
    }

    protected void SetState(TicketMachineState newState)
    {
        if(state != null)
        {
            state.Cleanup();
        }

        state = newState;
        state.Initialize();
    }

    public void Run()
    {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Włączamy automat");

        while(true)
        {
            String input = scanner.nextLine();
            state.HandleInput(input);
        }

    }
}
