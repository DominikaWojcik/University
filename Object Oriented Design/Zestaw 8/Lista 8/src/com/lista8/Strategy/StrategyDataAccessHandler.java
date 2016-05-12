package com.lista8.Strategy;

/**
 * Created by dziku on 11.05.16.
 */
public class StrategyDataAccessHandler
{
    private IDataAccessStrategy strategy;

    public StrategyDataAccessHandler(IDataAccessStrategy strategy)
    {
        this.strategy = strategy;
    }

    public void Execute()
    {
        strategy.Connect();
        strategy.GetData();
        strategy.ProcessData();
        strategy.CloseConnection();
    }
}
