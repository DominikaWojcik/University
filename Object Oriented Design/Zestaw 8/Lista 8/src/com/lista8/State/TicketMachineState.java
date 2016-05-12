package com.lista8.State;

/**
 * Created by dziku on 12.05.16.
 */
public abstract class TicketMachineState
{
    protected TicketMachine machine;

    public TicketMachineState(TicketMachine machine)
    {
        this.machine = machine;
    }

    public abstract void HandleInput(String input);

    public abstract void Initialize();

    public abstract void Cleanup();
}
