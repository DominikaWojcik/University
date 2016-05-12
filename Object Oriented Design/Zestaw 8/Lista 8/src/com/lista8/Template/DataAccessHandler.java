package com.lista8.Template;

/**
 * Created by dziku on 11.05.16.
 */
public abstract class DataAccessHandler
{
    protected abstract void Connect();
    protected abstract void GetData();
    protected abstract void ProcessData();
    protected abstract void CloseConnection();

    public final void Execute()
    {
        Connect();
        GetData();
        ProcessData();
        CloseConnection();
    }
}
