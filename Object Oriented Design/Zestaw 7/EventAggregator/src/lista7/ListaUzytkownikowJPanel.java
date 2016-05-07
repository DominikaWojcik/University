package lista7;

import javax.jws.soap.SOAPBinding;
import javax.swing.*;
import javax.swing.event.TreeSelectionEvent;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Dziku on 2016-05-06.
 */
public class ListaUzytkownikowJPanel extends JPanel implements ISubscriber
{
    private JTable dataTable;
    private JButton addButton;
    private JScrollPane scrollPane;

    private User.Type state = User.Type.Other;

    public ListaUzytkownikowJPanel(LayoutManager layout)
    {
        super(layout);
        Initialize();
    }

    public ListaUzytkownikowJPanel(LayoutManager layout, boolean isDoubleBuffered)
    {
        super(layout, isDoubleBuffered);
        Initialize();
    }

    public ListaUzytkownikowJPanel(boolean isDoubleBuffered)
    {
        super(isDoubleBuffered);
        Initialize();
    }

    public ListaUzytkownikowJPanel()
    {
        super();
        Initialize();
    }

    private void Initialize()
    {
        //setLayout(new FlowLayout());

        addButton = new JButton("Add");
        addButton.addActionListener(new ActionListener()
        {
            @Override
            public void actionPerformed(ActionEvent e)
            {
                AddUsersDialog dialog = new AddUsersDialog((Frame)null, "Dodaj uzytkownikow", true);
                dialog.setVisible(true);
            }
        });

        dataTable = new JTable(DataBank.Instance().GetData(), DataBank.columns);
        dataTable.setEnabled(false);

        scrollPane = new JScrollPane(dataTable);
        add(scrollPane);
        //add(dataTable);
        add(addButton);

    }

    @Override
    public void HandleNotification(Object notification)
    {
        if(notification instanceof TreeSelectionEvent)
        {
            HandleNotification((TreeSelectionEvent) notification);
        }
        else if(notification instanceof AddUsersDialogConfirm)
        {
            HandleNotification((AddUsersDialogConfirm) notification);
        }
    }

    private void HandleNotification(TreeSelectionEvent notification)
    {
        //Jak costam klikniete, to widoczne, jak cos innego to niewidoczne
        System.out.println("ListaUzytkownikow obsluguje cos!");
        String text = notification.getNewLeadSelectionPath().getLastPathComponent().toString();

        switch (text)
        {
            case "Root":
                setVisible(false);
                remove(scrollPane);
                dataTable = new JTable(DataBank.Instance().GetData(), DataBank.columns);
				dataTable.setEnabled(false);
                scrollPane = new JScrollPane(dataTable);
                add(scrollPane);
                setVisible(true);

                state = User.Type.Other;
                System.out.println("Lis. uz. root.");
                break;
            case "Studenci":
                setVisible(false);
                remove(scrollPane);
                dataTable = new JTable(DataBank.Instance().GetData(User.Type.Student), DataBank.columns);
				dataTable.setEnabled(false);
                scrollPane = new JScrollPane(dataTable);
                add(scrollPane);
                setVisible(true);

                state = User.Type.Student;
                System.out.println("Lis. uz. stud");
                break;
            case "Wykladowcy":
                setVisible(false);
                remove(scrollPane);
                dataTable = new JTable(DataBank.Instance().GetData(User.Type.Teacher), DataBank.columns);
				dataTable.setEnabled(false);
                scrollPane = new JScrollPane(dataTable);
                add(scrollPane);
                setVisible(true);

                state = User.Type.Teacher;
                System.out.println("Lis. uz. teach");
                break;
            default:
                System.out.println("Lista uzytkownikow visible -> false");
                setVisible(false);

        }
    }

    private void HandleNotification(AddUsersDialogConfirm notification)
    {
        setVisible(false);
        remove(scrollPane);
        if(state.equals(User.Type.Other))
        {
            dataTable = new JTable(DataBank.Instance().GetData(), DataBank.columns);
        }
        else
        {
            dataTable = new JTable(DataBank.Instance().GetData(state), DataBank.columns);
        }
		dataTable.setEnabled(false);
        scrollPane = new JScrollPane(dataTable);
        add(scrollPane);
        setVisible(true);
    }
}
