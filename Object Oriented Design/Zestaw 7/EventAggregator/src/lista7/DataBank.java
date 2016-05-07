package lista7;

import java.util.ArrayList;
import java.util.Collection;

/**
 * Created by Dziku on 2016-05-06.
 */
public class DataBank
{
    private static DataBank instance;
    public static String[] columns = {"Nazwisko", "Imię", "Data urodzenia", "Adres"};
    private ArrayList<User> users;

    private DataBank()
    {
        users = new ArrayList<>();
        users.add(new User("Artur", "Babacki", "1995", "ul. Jakaśtam", User.Type.Student, "Jakies informacje 1"));
        users.add(new User("Edward", "Fabacki", "1985", "ul. Gdzieś", User.Type.Teacher, "Jakies informacje 2"));
        users.add(new User("Hubert", "Ibacki", "1975", "ul. Coś", User.Type.Student, "Jakies informacje 3"));
        users.add(new User("Kacper", "Labacki", "1965", "ul. Ulica", User.Type.Teacher, "Jakies informacje 4"));
    }

    public static DataBank Instance()
    {
        if(instance == null)
        {
            instance = new DataBank();
        }
        return instance;
    }

    public static Object[][] ListToArray(ArrayList<User> list)
    {
        Object[][] data = new Object[list.size()][4];
        for(int i = 0; i < list.size(); ++i)
        {
            User u = list.get(i);
            data[i][0] = u.getLastName();
            data[i][1] = u.getName();
            data[i][2] = u.getDateOfBirth();
            data[i][3] = u.getAddress();
        }
        return data;
    }

    public Object[][] GetData()
    {
        return ListToArray(users);
    }

    public Object[][] GetData(User.Type type)
    {
        ArrayList<User> selected = new ArrayList<>();
        for (User user : users)
        {
            if(user.getType().equals(type))
            {
                selected.add(user);
            }
        }

        return ListToArray(selected);
    }

    public ArrayList<User> GetUsers()
    {
        return users;
    }

    public ArrayList<User> GetUsers(User.Type type)
    {
        ArrayList<User> selection = new ArrayList<>();
        for(User user : users)
        {
            if(user.getType().equals(type))
            {
                selection.add(user);
            }
        }

        return selection;
    }

    public User GetUser(String name, String lastName) throws IllegalArgumentException
    {
        for(User user : users)
        {
            if(user.getLastName().equals(lastName) && user.getName().equals(name))
            {
                return user;
            }
        }
        throw new IllegalArgumentException("No such user");
    }

    public void AddUser(User user)
    {
        users.add(user);
    }

    public void AddUser(Collection<User> newUsers)
    {
        users.addAll(newUsers);
    }


}
