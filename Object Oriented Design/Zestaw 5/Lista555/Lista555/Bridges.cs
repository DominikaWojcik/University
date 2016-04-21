using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista555
{

//PIERWSZA WERSJA - WSTRZYKUJEMY IMPLEMENACJE ŁADOWANIA LISTY LUDZI

    //Bridge
    public abstract class NotifierPersonRegistry
    {
        protected List<Person> people = new List<Person>();
        private IPeopleLoader loader;

        public NotifierPersonRegistry(IPeopleLoader loader)
        {
            this.loader = loader;
        }

        public abstract void NotifyPeople();

        public void LoadPeople()
        {
            loader.LoadPeople(people);
        }
    }

    public interface IPeopleLoader
    {
        void LoadPeople(List<Person> people);
    }

    public class SmsPersonRegistry : NotifierPersonRegistry
    {
        public SmsPersonRegistry(IPeopleLoader loader) : base(loader)
        {
        }

        public override void NotifyPeople()
        {
            Console.WriteLine("SmsPersonRegistry - Powiadamiam osoby sms'em");
        }
    }

    public class MailPersonRegistry : NotifierPersonRegistry
    {
        public MailPersonRegistry(IPeopleLoader loader) : base(loader)
        {
        }

        public override void NotifyPeople()
        {
            Console.WriteLine("MailPersonRegistry - Powiadamiam osoby mailem");
        }
    }

    public class XmlPeopleLoader : IPeopleLoader
    {
        public void LoadPeople(List<Person> people)
        {
            Console.WriteLine("XmlPeopleLoader - Wczytuję dane ludzi z XML");
        }
    }

    public class DatabasePeopleLoader : IPeopleLoader
    {
        public void LoadPeople(List<Person> people)
        {
            Console.WriteLine("DatabasePeopleLoader - Wczytuję dane ludzi z bazy danych");
        }
    }

//
//DRUGA WERSJA - WSTRZYKUJEMY SPOSÓB POWIADAMIANIA
//

    public abstract class LoaderPersonRegistry
    {
        protected List<Person> people = new List<Person>();
        private IPeopleNotifier notifier;

        public LoaderPersonRegistry(IPeopleNotifier notifier)
        {
            this.notifier = notifier;
        }

        public void NotifyPeople()
        {
            notifier.NotifyPeople(people);
        }

        public abstract void LoadPeople();
    }

    public interface IPeopleNotifier
    {
        void NotifyPeople(List<Person> people);
    }

    public class XmlPersonRegistry : LoaderPersonRegistry
    {
        public XmlPersonRegistry(IPeopleNotifier notifier) : base(notifier)
        {
        }

        public override void LoadPeople()
        {
            Console.WriteLine("XmlPersonRegistry - Wczytuje ludzi z XML");
        }
    }


    public class DatabasePersonRegistry : LoaderPersonRegistry
    {
        public DatabasePersonRegistry(IPeopleNotifier notifier) : base(notifier)
        {
        }

        public override void LoadPeople()
        {
            Console.WriteLine("DatabasePersonRegistry - Wczytuje ludzi z bazy danych");
        }
    }

    public class SmsPeopleNotifier : IPeopleNotifier
    {

        public void NotifyPeople(List<Person> people)
        {
            Console.WriteLine("SmsPeopleNotifier - powiadamia ludzi sms'em");
        }
    }

    public class MailPeopleNotifier : IPeopleNotifier
    {

        public void NotifyPeople(List<Person> people)
        {
            Console.WriteLine("MailPeopleNotifier - powiadamia ludzi mailem");
        }
    }

    public class Person { }
}
