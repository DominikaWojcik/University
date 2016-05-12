package com.lista8.Command;

/**
 * Created by dziku on 11.05.16.
 */
public class CopyFileCommand implements ICommand
{
    String path, newPath;

    public CopyFileCommand(String path, String newPath)
    {
        this.path = path;
        this.newPath = newPath;
    }

    public void Execute()
    {
        FileManager.Instance().CopyFile(path, newPath);
    }
}
