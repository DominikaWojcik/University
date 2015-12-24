/**
 *
 * @author Dziku
 */
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class EdycjaPojazdu extends JPanel
{
    Pojazd pojazd;
    JLabel lmarka,lmodel,lrocznik;
    JTextField marka,model,rocznik;
    JButton zapisz;
    String sciezka;
    
    public EdycjaPojazdu(Pojazd pojazd,String sciezka)
    {
        this.sciezka=sciezka;
        this.pojazd=pojazd;
        setLayout(new FlowLayout());
        lmarka=  new JLabel("Marka");
        add(lmarka);
        marka = new JTextField(pojazd.marka, 20);
        add(marka);
        lmodel = new JLabel("Model");
        add(lmodel);
        model = new JTextField(pojazd.model, 20);
        add(model);
        lrocznik = new JLabel("Rocznik");
        add(lrocznik);
        rocznik = new JTextField(pojazd.rocznik, 20);
        add(rocznik);
        zapisz = new JButton("Zapisz");
        zapisz.addActionListener(
            new ActionListener()
            {
                public void actionPerformed(ActionEvent evt)
                {
                    pojazd.marka=marka.getText();
                    pojazd.model=model.getText();
                    pojazd.rocznik = rocznik.getText();
                    pojazd.zapisz(sciezka);
                    System.out.println("Zapisano "+pojazd);
                }
            });
        add(zapisz);
    }
}
