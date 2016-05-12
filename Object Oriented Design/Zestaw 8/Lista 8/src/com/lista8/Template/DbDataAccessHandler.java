package com.lista8.Template;

import java.sql.*;
import java.math.*;
import java.util.ArrayList;

import org.postgresql.*;
/**
 * Created by dziku on 11.05.16.
 */
public class DbDataAccessHandler extends DataAccessHandler
{
    private Connection connection;

    private ArrayList<User> users = new ArrayList<>();

    @Override
    protected void Connect()
    {
        try
        {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/dziku",
                    "dziku", "a");

            System.out.println("Ustanowiono połączenie z bazą danych");
        }
        catch (ClassNotFoundException e)
        {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
        catch (SQLException e)
        {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    @Override
    protected void GetData()
    {
        try
        {
            Statement statement = connection.createStatement();
            ResultSet data = statement.executeQuery("SELECT * FROM users;");

            users.clear();

            while(data.next())
            {
                int id = data.getInt("id");
                String imie = data.getString("imie");
                String nazwisko = data.getString("nazwisko");
                Date dataUr = data.getDate("dataur");

                System.out.println(Integer.toString(id) + " " + imie + " " + nazwisko + " " + dataUr.toString());

                users.add(new User(id, imie, nazwisko, dataUr));
            }

            data.close();
            statement.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    @Override
    protected void ProcessData()
    {
        int sumaId = 0;
        for (User user : users)
        {
            sumaId += user.getId();
        }

        System.out.println("Suma identyfikatorów użytkowników wynosi " + Integer.toString(sumaId));
    }

    @Override
    protected void CloseConnection()
    {
        try
        {
            connection.close();
            System.out.println("Zamknięto połączenie");
        }
        catch (SQLException e)
        {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }
}
