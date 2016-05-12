package com.lista8.Template;

import java.util.Date;

/**
 * Created by dziku on 11.05.16.
 */
public class User
{
    private int id;
    private String imie, nazwisko;
    private Date dataUr;

    public User(int id, String imie, String nazwisko, Date dataUr)
    {
        this.id = id;
        this.imie = imie;
        this.nazwisko = nazwisko;
        this.dataUr = dataUr;
    }

    public Date getDataUr()
    {
        return dataUr;
    }

    public String getImie()
    {
        return imie;
    }

    public int getId()
    {
        return id;
    }

    public String getNazwisko()
    {
        return nazwisko;
    }
}
