package lista7;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;

/**
 * Created by Dziku on 2016-05-06.
 */
public class AddUsersDialog extends JDialog implements ActionListener
{
    private JTextField name, lastName, address, dateOfBirth;
    private JComboBox<User.Type> type;
    private JButton addButton;

    public AddUsersDialog(Frame owner, String title, boolean modal)
    {
        super(owner, title, modal);
        Initialize();
    }

    private void Initialize()
    {
        setLayout(new GridLayout(0,2));

        name = new JTextField();
        lastName = new JTextField();
        address = new JTextField();
        dateOfBirth = new JTextField();

        type = new JComboBox<>(User.Type.values());

        addButton = new JButton("Add");
        addButton.addActionListener(this);

        add(new JLabel("Imię"));
        add(name);
        add(new JLabel("Nazwisko"));
        add(lastName);
        add(new JLabel("Adres"));
        add(address);
        add(new JLabel("Data urodzenia"));
        add(dateOfBirth);
        add(new JLabel("Rodzaj"));
        add(type);
        add(addButton);

        setSize(400, 300);
    }

    @Override
    public void actionPerformed(ActionEvent e)
    {
        User user = new User(lastName.getText(),
                name.getText(),
                dateOfBirth.getText(),
                address.getText(),
                (User.Type) type.getSelectedItem(),
                "Brak informacji.");

        DataBank.Instance().AddUser(user);

        EventAggregator.Instance().Publish(
                AddUsersDialogConfirm.class.getSimpleName(),
                new AddUsersDialogConfirm(user));

        dispose();
    }
}
