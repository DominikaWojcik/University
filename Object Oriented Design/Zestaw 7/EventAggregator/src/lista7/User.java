package lista7;

/**
 * Created by Dziku on 2016-05-06.
 */
public class User
{
    private String name;
    private String lastName;
    private String dateOfBirth;
    private String address;
    private Type type = Type.Other;
    private String kartoteka = "";

    public enum Type
    {
        Student,
        Teacher,
        Other
    }

    public User(String name, String lastName, String dateOfBirth, String address, Type type)
    {
        this.name = name;
        this.lastName = lastName;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.type = type;
    }

    public User(String name, String lastName, String dateOfBirth, String address, Type type, String kartoteka)
    {
        this.name = name;
        this.lastName = lastName;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.type = type;
        this.kartoteka = kartoteka;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getDateOfBirth()
    {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth)
    {
        this.dateOfBirth = dateOfBirth;
    }

    public String getLastName()
    {
        return lastName;
    }

    public void setLastName(String lastName)
    {
        this.lastName = lastName;
    }

    public String getAddress()
    {
        return address;
    }

    public void setAddress(String address)
    {
        this.address = address;
    }

    public Type getType()
    {
        return type;
    }

    public void setType(Type type)
    {
        this.type = type;
    }

    public String getKartoteka()
    {
        return this.kartoteka;
    }

    public void setKartoteka(String kartoteka)
    {
        this.kartoteka = kartoteka;
    }
}
