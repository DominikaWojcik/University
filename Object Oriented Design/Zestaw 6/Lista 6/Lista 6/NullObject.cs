using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_6
{
    public interface ILogger
    {
        void Log(string Message);
    }

    public enum LogType { None, Console, File}

    public class LoggerFactory
    {
        private static LoggerFactory instance;

        private LoggerFactory() { }

        public ILogger GetLogger(LogType LogType, string Parameters = null)
        {
            switch(LogType)
            {
                case LogType.Console:
                    return new ConsoleLogger();
                case LogType.File:
                    return new FileLogger(Parameters);
                default:
                    return new NullObjectLogger();
            }
        }

        public static LoggerFactory Instance
        {
            get
            {
                if(instance == null)
                {
                    instance = new LoggerFactory();
                }
                return instance;
            }
        }
    }

    public class ConsoleLogger : ILogger
    {
        public void Log(string Message)
        {
            Console.WriteLine(Message);
        }
    }

    public class FileLogger : ILogger
    {
        private StreamWriter writer;
        public FileLogger(string Path)
        {
            writer = new StreamWriter(Path, true);
            writer.AutoFlush = true;
        }

        public void Log(string Message)
        {
            writer.WriteLine(Message);
        }
    }

    public class NullObjectLogger : ILogger
    {
        public void Log(string Message)
        {
            // Doing absolutely nothing
        }
    }


}
