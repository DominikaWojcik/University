package lista7;

import javax.swing.*;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class Main {

    public static void main(String[] args) throws InterruptedException
    {
        JFrame frame = new JFrame();
        frame.setTitle("Kartoteka");
        frame.setSize(800, 600);
        frame.addWindowListener(new WindowAdapter()
        {
            @Override
            public void windowClosing(WindowEvent e)
            {
                super.windowClosing(e);
                System.exit(0);
            }
        });

        JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        splitPane.setDividerLocation(150);

        MyJTree treeView = new MyJTree();

        EventAggregator.Instance().AddSubscriber(
                KartotekaEditDialogClose.class.getSimpleName(), treeView);
        EventAggregator.Instance().AddSubscriber(
                AddUsersDialogConfirm.class.getSimpleName(), treeView);

        JPanel rightPanel = new JPanel();
        KartotekaJPanel kartoteka = new KartotekaJPanel();
        ListaUzytkownikowJPanel lista = new ListaUzytkownikowJPanel();

        EventAggregator.Instance().AddSubscriber(
                TreeSelectionEvent.class.getSimpleName(), kartoteka);
        EventAggregator.Instance().AddSubscriber(
                KartotekaEditDialogClose.class.getSimpleName(), kartoteka);

        EventAggregator.Instance().AddSubscriber(
                TreeSelectionEvent.class.getSimpleName(), lista);
        EventAggregator.Instance().AddSubscriber(
                AddUsersDialogConfirm.class.getSimpleName(), lista);



        kartoteka.setVisible(false);
        rightPanel.add(kartoteka);
        rightPanel.add(lista);

        splitPane.setLeftComponent(treeView);
        splitPane.setRightComponent(rightPanel);
        frame.add(splitPane);
        frame.setVisible(true);
    }
}
