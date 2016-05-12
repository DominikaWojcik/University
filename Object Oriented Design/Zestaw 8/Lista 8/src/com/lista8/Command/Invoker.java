package com.lista8.Command;

import java.util.Date;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Random;

/**
 * Created by dziku on 11.05.16.
 */
public class Invoker
{
    private final int MIN_GENERATOR_SLEEP_TIME = 100;
    private final int MAX_GENERATOR_SLEEP_TIME = 1000;

    private final int MIN_DISPATCHER_SLEEP_TIME = 300;
    private final int MAX_DISPATCHER_SLEEP_TIME = 2000;

    private final int QUEUE_SIZE = 16;

    private Queue<ICommand> commandQueue = new LinkedList<>();

    private final Object notEmpty = new Object(), notFull = new Object();

    public void Run()
    {
        Thread generator = new Thread()
        {
            public void run()
            {
                System.out.println("Uruchamiam generator");
                Generate();
            }
        };

        Thread dispatcher1 = new Thread()
        {
            public void run()
            {
                System.out.println("Uruchamiam dis1");
                Dispatch();
            }
        };

        Thread dispatcher2 = new Thread()
        {
            public void run()
            {
                System.out.println("Uruchamiam dis2");
                Dispatch();
            }
        };

        generator.start();
        dispatcher1.start();
        dispatcher2.start();
    }

    private void Generate()
    {
        Random rand = new Random(new Date().getTime());
        ICommand command;

        while(true)
        {
            switch (rand.nextInt() % 4)
            {
                case 0:
                    command = new DownloadFtpCommand("Some ftp address " + Integer.toString(rand.nextInt()));
                    break;
                case 1:
                    command = new DownloadHttpCommand("Some http address " + Integer.toString(rand.nextInt()));
                    break;
                case 2:
                    command = new CreateFileCommand("Some path " + Integer.toString(rand.nextInt()));
                    break;
                default:
                    command = new CopyFileCommand("Some original address " + Integer.toString(rand.nextInt()),
                            "Some new address " + Integer.toString(rand.nextInt()));
                    break;
            }

            AddCommand(command);

            try
            {
                Thread.sleep(rand.nextInt(Integer.MAX_VALUE) % (MAX_GENERATOR_SLEEP_TIME - MIN_GENERATOR_SLEEP_TIME + 1) + MIN_GENERATOR_SLEEP_TIME);
            }
            catch (InterruptedException e)
            {
                e.printStackTrace();
            }
        }
    }

    private void Dispatch()
    {
        Random rand = new Random(new Date().getTime());

        while(true)
        {
            ICommand command = GetCommand();
            command.Execute();

            try
            {
                Thread.sleep(rand.nextInt(Integer.MAX_VALUE) % (MAX_DISPATCHER_SLEEP_TIME - MIN_DISPATCHER_SLEEP_TIME + 1) + MIN_DISPATCHER_SLEEP_TIME);
            }
            catch (InterruptedException e)
            {
                e.printStackTrace();
            }
        }
    }

    private synchronized void AddCommand(ICommand command)
    {
        while(commandQueue.size() >= QUEUE_SIZE)
        {
            try
            {
                this.wait();
            } catch (InterruptedException e)
            {
                e.printStackTrace();
            }
        }

        commandQueue.add(command);
        this.notifyAll();
    }

    private synchronized ICommand GetCommand()
    {
        while(commandQueue.isEmpty())
        {
            try
            {
                this.wait();
            } catch (InterruptedException e)
            {
                e.printStackTrace();
            }
        }

        ICommand command = commandQueue.remove();
        this.notifyAll();

        return command;
    }
}
