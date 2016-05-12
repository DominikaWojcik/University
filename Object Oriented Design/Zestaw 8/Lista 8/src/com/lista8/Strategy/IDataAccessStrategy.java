package com.lista8.Strategy;

/**
 * Created by dziku on 11.05.16.
 */
public interface IDataAccessStrategy
{
    void Connect();
    void GetData();
    void ProcessData();
    void CloseConnection();
}
