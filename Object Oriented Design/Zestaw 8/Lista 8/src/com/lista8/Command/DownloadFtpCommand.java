package com.lista8.Command;

/**
 * Created by dziku on 11.05.16.
 */
public class DownloadFtpCommand implements ICommand
{
    String address;

    public DownloadFtpCommand(String address)
    {
        this.address = address;
    }

    public void Execute()
    {
        FileManager.Instance().DownloadFileFTP(address);
    }
}
