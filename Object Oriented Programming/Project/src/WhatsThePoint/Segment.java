package WhatsThePoint;

import static WhatsThePoint.Vector2D.sub;
import java.awt.BasicStroke;
import java.awt.Canvas;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.io.Serializable;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Circle;


public class Segment implements Serializable
{
    Vector2D end1, end2;
    float width;

    public Segment() 
    {
        end1 = new Vector2D();
        end2 = new Vector2D();
        width = 0;
    }

    public Segment(Vector2D end1, Vector2D end2, float width)
    {
        this.end1 = end1;
        this.end2 = end2;
        this.width = width;
    }

    public boolean crosses(Dot dot) {
        Vector2D segTo00 = sub(end2, end1), centerTo00 = sub(dot.center, end1);

        if (Vector2D.distance(centerTo00, segTo00) < width / 2.0 + dot.radius) {
            return true;
        } else if (centerTo00.length() < width / 2.0 + dot.radius) {
            return true;
        }

        //System.out.println("Sprawdzamy rzut na podprzestrzeń!");
        Vector2D proj = Vector2D.projectToLin(centerTo00, segTo00);
        
        System.out.println(segTo00);
        System.out.println(centerTo00);
        System.out.println(proj);
        
        System.out.println(Vector2D.distance(proj, centerTo00));
        
        return (Vector2D.distance(proj, centerTo00) < width / 2.0 + dot.radius
                && proj.length() <= segTo00.length() && Vector2D.sameDirection(proj, segTo00));

    }
    
    public void setEnd2Pos(float x, float y)
    {
        end2 = new Vector2D(x,y);
    }
    
    public void paint(Graphics g)
    {
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setStroke(new BasicStroke(width));
        g2d.setColor(Color.BLACK);
        
        g2d.draw(new Line2D.Float(end1.x,end1.y,end2.x,end2.y));
        g2d.setColor(Color.BLUE);
        g2d.fill(new Ellipse2D.Float(end1.x - width/2.0f,end1.y - width/2.0f,width,width));
        g2d.setColor(Color.red);
        g2d.fill(new Ellipse2D.Float(end2.x - width/2.0f,end2.y - width/2.0f,width,width));
    }
    
    @Override
    public String toString()
    {
        return "Segment "+end1.toString()+", "+end2.toString();
    }
}
