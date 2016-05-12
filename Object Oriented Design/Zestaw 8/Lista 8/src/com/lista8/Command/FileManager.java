package com.lista8.Command;

/**
 * Created by dziku on 11.05.16.
 */
public class FileManager
{
    private static FileManager instance;
    private static final Object lock = new Object();

    private FileManager() { }

    public static FileManager Instance()
    {
        if(instance == null)
        {
            synchronized (lock)
            {
                if(instance == null)
                {
                    instance = new FileManager();
                }
            }
        }
        return instance;
    }

    public static void DownloadFileFTP(String address)
    {
        System.out.println("Pobieranie pliku FTP: " + address);
    }

    public static void DownloadFileHTTP(String address)
    {
        System.out.println("Pobieranie pliku HTTP: " + address);
    }

    public static void CreateAndFillFile(String path)
    {
        System.out.println("Tworzenie i wypełnianie pliku " + path);
    }

    public static void CopyFile(String path, String newPath)
    {
        System.out.println("Kopiowanie pliku  " + path + " do " + newPath);
    }
}
