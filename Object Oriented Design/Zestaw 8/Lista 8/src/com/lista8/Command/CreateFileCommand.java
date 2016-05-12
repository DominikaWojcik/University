package com.lista8.Command;

/**
 * Created by dziku on 11.05.16.
 */
public class CreateFileCommand implements ICommand
{
    String path;

    public CreateFileCommand(String path)
    {
        this.path = path;
    }

    public void Execute()
    {
        FileManager.Instance().CreateAndFillFile(path);
    }
}
