package WhatsThePoint;

import java.awt.Color;
import java.awt.Graphics;
import javax.swing.JPanel;


public class GameArea extends JPanel
{
    Model model;
    public GameArea()
    {
        super();
    }
    
    public GameArea(Model model)
    {
        super();
        this.model = model;
    }
    
    @Override
    public void paint(Graphics g)
    {
        //System.out.println("sada");
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, getWidth(), getHeight());
        g.setColor(Color.BLACK);
        drawGrid(g,50);
        model.paint(g);      
    }
    
    private void drawGrid(Graphics g, int freq)
    {
        for(int i=0;i<=this.getWidth();i+=freq)
            g.drawLine(i, 0, i, this.getHeight());
        for(int i=0;i<=this.getHeight();i+=freq)
            g.drawLine(0, i,this.getWidth(),i);
    }

}
