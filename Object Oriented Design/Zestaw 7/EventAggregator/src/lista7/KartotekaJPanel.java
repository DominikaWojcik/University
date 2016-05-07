package lista7;

import sun.reflect.generics.tree.Tree;

import javax.swing.*;
import javax.swing.event.TreeSelectionEvent;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Dziku on 2016-05-06.
 */
public class KartotekaJPanel extends JPanel implements ISubscriber
{
    private JLabel name, lastName, address, dateOfBirth;
    private JTextArea kartoteka;
    private JButton modifyButton;

    private User user;

    public KartotekaJPanel(LayoutManager layout, boolean isDoubleBuffered)
    {
        super(layout, isDoubleBuffered);
        Initialize();
    }

    public KartotekaJPanel(LayoutManager layout)
    {
        super(layout);
        Initialize();
    }

    public KartotekaJPanel(boolean isDoubleBuffered)
    {
        super(isDoubleBuffered);
        Initialize();
    }

    public KartotekaJPanel()
    {
        super();
        Initialize();
    }

    private void Initialize()
    {
        modifyButton = new JButton("Modify");
        modifyButton.addActionListener(new ActionListener()
        {
            @Override
            public void actionPerformed(ActionEvent e)
            {
                KartotekaEditDialog dialog = new KartotekaEditDialog(null, "Edit", true, user);
                dialog.setSize(400, 300);
                dialog.setVisible(true);
            }
        });

        JPanel panel = new JPanel();
        panel.setLayout(new GridLayout(0, 1));

        name = new JLabel();
        lastName = new JLabel();
        address = new JLabel();
        dateOfBirth = new JLabel();
        kartoteka = new JTextArea(5, 10);
        kartoteka.setEditable(false);

        panel.add(name);
        panel.add(lastName);
        panel.add(address);
        panel.add(dateOfBirth);
        panel.add(modifyButton);
        add(panel);
        add(kartoteka);
    }

    private void ModifyData(User user)
    {
        name.setText("Imię: " + user.getName());
        lastName.setText("Nazwisko: " + user.getLastName());
        address.setText("Adres: " + user.getAddress());
        dateOfBirth.setText("Data urodzenia: " + user.getDateOfBirth());
        kartoteka.setText(user.getKartoteka());
    }

    @Override
    public void HandleNotification(Object notification)
    {
        if(notification instanceof TreeSelectionEvent)
        {
            HandleNotification((TreeSelectionEvent) notification);
        }
        else if(notification instanceof KartotekaEditDialogClose)
        {
            HandleNotification((KartotekaEditDialogClose) notification);
        }
    }

    private void HandleNotification(TreeSelectionEvent e)
    {
        //Jesli ktostam, to costam
        System.out.println("Kartoteka panel obsluguje costam innego");
        String text = e.getNewLeadSelectionPath().getLastPathComponent().toString();

        if(text.equals("Root") || text.equals("Studenci") || text.equals("Wykladowcy"))
        {
            System.out.println("Kartoteka panel visible -> false");
            setVisible(false);
        }
        else
        {
            System.out.println("Kartoteka panel visible -> true");
            String[] split = text.split(" ");
            String uLastName = split[0];
            String uName = split[1];
            user = DataBank.Instance().GetUser(uName, uLastName);

            ModifyData(user);

            setVisible(true);
        }
    }

    private void HandleNotification(KartotekaEditDialogClose notification)
    {
        ModifyData(notification.getUser());
    }
}
