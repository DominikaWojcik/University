package lista7;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

/**
 * Created by Dziku on 2016-05-07.
 */
public class KartotekaEditDialog extends JDialog implements ActionListener
{
    JTextField name, lastName, address, dateOfBirth;
    JTextArea info;
    JButton saveButton;
    User user;

    public KartotekaEditDialog(Frame owner, String title, boolean modal, User user)
    {
        super(owner, title, modal);
        this.user = user;

        Initialize();
    }

    private void Initialize()
    {
        name = new JTextField(user.getName());
        lastName = new JTextField(user.getLastName());
        address = new JTextField(user.getAddress());
        dateOfBirth = new JTextField(user.getDateOfBirth());
        info = new JTextArea(user.getKartoteka());
        info.setEditable(true);

        saveButton = new JButton("Save");
        saveButton.addActionListener(this);

        setLayout(new GridLayout(0, 2));

        add(new JLabel("Imię"));
        add(name);
        add(new JLabel("Nazwisko"));
        add(lastName);
        add(new JLabel("Adres"));
        add(address);
        add(new JLabel("Data urodzenia"));
        add(dateOfBirth);
        add(new JLabel("Info"));
        add(info);
        add(saveButton);
    }

    @Override
    public void actionPerformed(ActionEvent e)
    {
        user.setName(name.getText());
        user.setLastName(lastName.getText());
        user.setAddress(address.getText());
        user.setDateOfBirth(dateOfBirth.getText());
        user.setKartoteka(info.getText());

        //Zawiadomic kartoteka jpanel oraz myjtree
        EventAggregator.Instance().Publish(
                KartotekaEditDialogClose.class.getSimpleName(), new KartotekaEditDialogClose(user));

        dispose();
    }
}
