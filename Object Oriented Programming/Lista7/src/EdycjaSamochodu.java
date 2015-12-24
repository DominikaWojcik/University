
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.*;


/**
 *
 * @author Dziku
 */
public class EdycjaSamochodu extends JPanel
{
    Samochod pojazd;
    JLabel lmarka,lmodel,lrocznik,lkolor;
    JTextField marka,model,rocznik,kolor;
    JButton zapisz;
    String sciezka;
    
    public EdycjaSamochodu(Samochod pojazd,String sciezka)
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
        lkolor = new JLabel("Kolor");
        add(lkolor);
        kolor = new JTextField(pojazd.kolor, 20);
        add(kolor);
        zapisz = new JButton("Zapisz");
        zapisz.addActionListener(
            new ActionListener()
            {
                public void actionPerformed(ActionEvent evt)
                {
                    pojazd.marka=marka.getText();
                    pojazd.model=model.getText();
                    pojazd.rocznik = rocznik.getText();
                    pojazd.kolor = kolor.getText();
                    pojazd.zapisz(sciezka);
                    System.out.println("Zapisano "+pojazd);
                }
            });
        add(zapisz);
    }
}
