package WhatsThePoint;

import java.awt.BasicStroke;
import java.awt.Canvas;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.io.Serializable;


public class Dot implements Serializable
{
    public Vector2D center;
    public float radius;
    
    public boolean ticked;
    
    public Dot()
    {
        center = new Vector2D();
        radius = 0;
        ticked = false;
    }
    
    public Dot(Vector2D center, float radius)
    {
        this.center = center;
        this.radius = radius;
        ticked = false;
    }
    
    public void paint(Graphics g)
    {
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        if(ticked==true)g2d.setColor(Color.green);
        else g2d.setColor(Color.red);
        g2d.fill(new Ellipse2D.Float(center.x-radius,center.y-radius,2*radius,2*radius));
    }
    
    @Override
    public String toString()
    {
        return "Dot "+center.toString()+", "+Float.toString(radius);
    }
}
