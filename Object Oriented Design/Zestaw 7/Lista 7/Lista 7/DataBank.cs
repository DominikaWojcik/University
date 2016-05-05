using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_7
{
    public class DataBank
    {
        private static DataBank instance;

        private List<User> users;

        private DataBank()
        {
            users = new List<User>();
            //FileStream fstream = new FileStream("data.txt", FileMode.Open, FileAccess.Read);
            users.Add(new User()
                {
                    Type = UserType.Student,
                    Name = "Adam",
                    LastName = "Kowalski",
                    Address = "Ul. Mickiewicza 3/5",
                    DateOfBirth = "24.04.1995"
                });
            users.Add(new User()
                {
                    Type = UserType.Teacher,
                    Name = "Bartosz",
                    LastName = "Nowak",
                    Address = "Ul. Słowackiego 3/5",
                    DateOfBirth = "14.08.1992"
                });
            users.Add(new User()
                {
                    Type = UserType.Student,
                    Name = "Zbigniew",
                    LastName = "Stonoga",
                    Address = "Al. Jerozolimskie 3/5",
                    DateOfBirth = "24.04.1985"
                });
            users.Add(new User()
                {
                    Type = UserType.Teacher,
                    Name = "Andrzej",
                    LastName = "Duda",
                    Address = "Krakowskie Przedmieście ileś",
                    DateOfBirth = "24.04.1975"
                });
        }

        public static DataBank Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new DataBank();
                }
                return instance;
            }
        }

        public List<User> GetUsers(UserType type)
        {
            return users.FindAll(delegate(User user) { return user.Type == type; });
        }
        public List<User> GetUsers()
        {
            return users;
        }
        public List<User> GetUsers(Predicate<User> match)
        {
            return users.FindAll(match);
        }

        public void AddUser(User user)
        {
            users.Add(user);
        }
    }

    public enum UserType
    {
        Student,
        Teacher
    }

    public class User
    {
        public string Name { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public string DateOfBirth { get; set; }
        public UserType Type { get; set; }
    }
}
