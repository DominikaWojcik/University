package WhatsThePoint;


import java.awt.Graphics;
import java.io.Serializable;
import java.util.ArrayList;



public class Plane implements Serializable
{
    public ArrayList<Segment> segments;
    public ArrayList<Dot> dots;
    
    public Plane()
    {
        segments = new ArrayList<>();
        dots = new ArrayList<>();
        //dots.add(new Dot(new Vector2D(200,200),30));
        //segments.add(new Segment(new Vector2D(300,300), new Vector2D(400,400), 10));
    }
    
    public Plane(ArrayList<Dot> dots)
    {
        segments = new ArrayList<>();
        this.dots = dots;
    }
    
    public void paint(Graphics g)
    {
        for(Dot dot: dots)
        {
            //System.out.println("Maluję dota\n");
            dot.paint(g);
        }
        for(Segment seg : segments)
        {
            seg.paint(g);
        }
        
    }
    
    @Override
    public String toString()
    {
        String out = "Dots:\n";
        for(Dot dot : dots)
           out+= dot.toString()+"\n";
        out+="Segments:\n";
        for(Segment seg: segments)
           out+= seg.toString()+"\n";
        return out;
    }

}
