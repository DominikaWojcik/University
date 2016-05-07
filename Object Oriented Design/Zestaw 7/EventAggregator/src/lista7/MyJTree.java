package lista7;

import javax.swing.*;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeModel;
import java.util.ArrayList;

/**
 * Created by Dziku on 2016-05-06.
 */
//Powinien implementować subscribera
public class MyJTree extends JTree implements ISubscriber
{
    public MyJTree()
    {
        super();
        addTreeSelectionListener(new TreeSelectionListener()
        {
            @Override
            public void valueChanged(TreeSelectionEvent e)
            {
                EventAggregator.Instance().Publish(
                        TreeSelectionEvent.class.getSimpleName(), e);
            }
        });

        Initialize();
    }

    private void Initialize()
    {
        Populate();
    }

    public void Populate()
    {
        DefaultMutableTreeNode root = new DefaultMutableTreeNode("Root");
        TreeModel treeModel = new DefaultTreeModel(root);

        DefaultMutableTreeNode studentNode = new DefaultMutableTreeNode("Studenci");
        DefaultMutableTreeNode teacherNode = new DefaultMutableTreeNode("Wykladowcy");

        ArrayList<User> students = DataBank.Instance().GetUsers(User.Type.Student);
        ArrayList<User> teachers = DataBank.Instance().GetUsers(User.Type.Teacher);

        for(User student : students)
        {
            studentNode.add(new DefaultMutableTreeNode(student.getLastName() + " " + student.getName()));
        }

        for(User teacher : teachers)
        {
            teacherNode.add(new DefaultMutableTreeNode(teacher.getLastName() + " " + teacher.getName()));
        }

        root.add(studentNode);
        root.add(teacherNode);

        setModel(treeModel);
    }

    @Override
    public void HandleNotification(Object notification)
    {
        if(notification instanceof KartotekaEditDialogClose)
        {
            HandleNotification((KartotekaEditDialogClose) notification);
        }
        else if(notification instanceof AddUsersDialogConfirm)
        {
            HandleNotification((AddUsersDialogConfirm) notification);
        }
    }

    private void HandleNotification(KartotekaEditDialogClose notification)
    {
        //do sth
        String path = getSelectionPath().getLastPathComponent().toString();
        System.out.println("Zamknięto okienko aktualizując węzeł z " + path);

        DefaultMutableTreeNode node = (DefaultMutableTreeNode) getLastSelectedPathComponent();
        String text = (String) node.getUserObject();
        User user = notification.getUser();
        setVisible(false);
        node.setUserObject(user.getLastName() + " " + user.getName());
        setVisible(true);
    }

    private void HandleNotification(AddUsersDialogConfirm notification)
    {
        //Kod dodający uzytkownika
        User user = notification.getUser();
        DefaultMutableTreeNode node = (DefaultMutableTreeNode) getModel().getRoot();

        if(user.getType().equals(User.Type.Student))
        {
            node = (DefaultMutableTreeNode) node.getChildAt(0);
        }
        else if(user.getType().equals(User.Type.Teacher))
        {
            node = (DefaultMutableTreeNode) node.getChildAt(1);
        }

        System.out.println("Dodaje do węzła " + node.getUserObject().toString() + " nowy wezel");

        DefaultTreeModel model = (DefaultTreeModel) getModel();
        model.insertNodeInto(
                new DefaultMutableTreeNode(user.getLastName() + " " + user.getName()),
                node, node.getChildCount());
    }
}
