package com.lista8.State;

/**
 * Created by dziku on 12.05.16.
 */
public class IdleState extends TicketMachineState
{
    public IdleState(TicketMachine machine)
    {
        super(machine);
    }

    @Override
    public void HandleInput(String input)
    {
        System.out.println("IdleState received input!");
        machine.SetState(new TicketSelectionState(machine));
    }

    @Override
    public void Initialize()
    {
        System.out.println("Initializing IdleState");
        System.out.println("Type any input to proceed");
    }

    @Override
    public void Cleanup()
    {
        System.out.println("Exiting IdleState");
    }
}
