package WhatsThePoint;

import java.util.ArrayList;


public class Main
{
    public static void main(String[] args)
    {
        
        Application.getInstance().initialize();
        Application.getInstance().run();
        Application.getInstance().cleanup();
        
        
        
       
    }
    
    public void prepareLevels()
    {
        ArrayList<Dot> lev1 = new ArrayList<>();
        lev1.add(new Dot(new Vector2D(100,100), 10));
        lev1.add(new Dot(new Vector2D(100,300), 10));
        lev1.add(new Dot(new Vector2D(100,500), 10));
        lev1.add(new Dot(new Vector2D(300,100), 10));
        lev1.add(new Dot(new Vector2D(300,300), 10));
        lev1.add(new Dot(new Vector2D(300,500), 10));
        lev1.add(new Dot(new Vector2D(500,100), 10));
        lev1.add(new Dot(new Vector2D(500,300), 10));
        lev1.add(new Dot(new Vector2D(500,500), 10));
        
        Plane level1 = new Plane(lev1);
        GameModel.savePlane("level1.ser",level1);
        
        Plane a = GameModel.loadPlane("level1.ser");
        
        System.out.println(a);
        
        ArrayList<Dot> lev2 = new ArrayList<>();
        lev2.add(new Dot(new Vector2D(300,300),10));
        Plane level2 = new Plane(lev2);
        GameModel.savePlane("level2.ser", level2);
        
        ArrayList<Dot> lev3 = new ArrayList<>();
        lev3.add(new Dot(new Vector2D(300,300), 10));
        lev3.add(new Dot(new Vector2D(300,400), 10));
        lev3.add(new Dot(new Vector2D(300,500), 10));
        lev3.add(new Dot(new Vector2D(400,300), 10));
        lev3.add(new Dot(new Vector2D(400,400), 10));
        lev3.add(new Dot(new Vector2D(400,500), 10));
        lev3.add(new Dot(new Vector2D(500,300), 10));
        lev3.add(new Dot(new Vector2D(500,400), 10));
        lev3.add(new Dot(new Vector2D(500,500), 10));
        
        Plane level3 = new Plane(lev3);
        GameModel.savePlane("level3.ser", level3);
               
        ArrayList<Dot> lev4 = new ArrayList<>();
        lev4.add(new Dot(new Vector2D(100,100),10));
        lev4.add(new Dot(new Vector2D(100,200),10));
        lev4.add(new Dot(new Vector2D(100,300),10));
        lev4.add(new Dot(new Vector2D(100,400),10));
        lev4.add(new Dot(new Vector2D(200,100),10));
        lev4.add(new Dot(new Vector2D(200,200),10));
        lev4.add(new Dot(new Vector2D(200,300),10));
        lev4.add(new Dot(new Vector2D(200,400),10));
        lev4.add(new Dot(new Vector2D(300,100),10));
        lev4.add(new Dot(new Vector2D(300,200),10));
        lev4.add(new Dot(new Vector2D(300,300),10));
        lev4.add(new Dot(new Vector2D(300,400),10));
        lev4.add(new Dot(new Vector2D(400,100),10));
        lev4.add(new Dot(new Vector2D(400,200),10));
        lev4.add(new Dot(new Vector2D(400,300),10));
        lev4.add(new Dot(new Vector2D(400,400),10));
        
        Plane level4 = new Plane(lev4);
        GameModel.savePlane("level4.ser", level4);
    }
}
