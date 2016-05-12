package com.lista8.Command;

/**
 * Created by dziku on 11.05.16.
 */
public class DownloadHttpCommand implements ICommand
{
    String address;

    public DownloadHttpCommand(String address)
    {
        this.address = address;
    }

    public void Execute()
    {
        FileManager.Instance().DownloadFileHTTP(address);
    }
}
