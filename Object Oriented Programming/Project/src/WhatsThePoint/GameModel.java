package WhatsThePoint;

import java.awt.Graphics;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;


class GameModel extends Model
{

    private Plane plane;
    private boolean firstPoint,blockGameArea;
    public String filePath;
    
    private float dotRadius;
    
    public GameModel()
    {
    }
    
    public GameModel(String filePath)
    {
        this.filePath = filePath;  
    }
    
    @Override
    public void update()
    {
        
    }
    
    private boolean allDotsTicked()
    {
        for(Dot dot: plane.dots)
            if(dot.ticked==false)return false;
        return true;
    }
    
    @Override
    public void initialize()
    {
        firstPoint = false;
        blockGameArea = false;
        dotRadius = 5;
        plane = loadPlane(filePath);
        System.out.println(plane);
        
        System.out.println(plane.dots.size());
        for(Dot dot: plane.dots)
        {
            if(dot.ticked == true)
                System.out.println("Dot zazanczony");
            else
                System.out.println("Dot niezaznaczony");
        }
    }
    
    public static Plane loadPlane(String filePath)
    {
        System.out.println("Próbuję wczytać plansze");
        
        FileInputStream fileIn;
        ObjectInputStream objIn;
        
        //File f = new File(filePath);
       // if(f.exists())
        //{
        Plane planeToLoad = new Plane();
            try
            {
                
                fileIn = new FileInputStream(filePath);
                objIn = new ObjectInputStream(fileIn);
                
                planeToLoad = (Plane)objIn.readObject();
                
                objIn.close();
                fileIn.close();
                
                System.out.println("Wczytano: \n"+planeToLoad.toString());
                
                /*for(int i=0;i<planeToLoad.dots.size();i++)
                    System.out.println(planeToLoad.dots.get(i));*/
            }
            catch(FileNotFoundException e)
            {
                System.err.println("Nie znaleziono pliku do wczytania!");
            }
            catch (IOException ex) {
                Logger.getLogger(GameModel.class.getName()).log(Level.SEVERE, null, ex);
            }
            catch(ClassNotFoundException e)
            {
                System.err.println("Nie znaleziono Plane'a do wczytania!");
            }  
            
        return planeToLoad;
            

        //}
        //else
        //{
         //   System.err.println("Plik o podanej scieżce nie istnieje!");
        //}       
        
    }
    
    public static void savePlane(String filePath, Plane planeToSave)
    {
        FileOutputStream fileOut;
        ObjectOutputStream objOut;
        
        try
        {
            fileOut = new FileOutputStream(filePath);
            objOut = new ObjectOutputStream(fileOut);
            
            objOut.writeObject(planeToSave);
            
            objOut.close();
            fileOut.close();
        }
        catch(IOException e)
        {
            
        }
    }
    
    @Override
    public void mouseClicked()
    {
        System.out.println("Klinknięto w pozycji "+Integer.toString(mousePosX)+" "+Integer.toString(mousePosY));
        
        if(blockGameArea == true)
        {
            System.out.println("Plansza zablokowana!");
            return;
        }
        
        if(firstPoint == false)
        {
            Segment toAdd = new Segment(new Vector2D(mousePosX,mousePosY),new Vector2D(mousePosX,mousePosY),2.0f * dotRadius);
            plane.segments.add(toAdd);
            firstPoint = true;
            System.out.println("PUNKT STARTOWY USTAWIONY");
        }
        else
        {
            Segment added = plane.segments.get(plane.segments.size()-1);
            Vector2D newEnd1 = added.end2;
            
            for(Dot dot: plane.dots)
            {
                if(added.crosses(dot))
                {
                    System.out.println(added.toString()+" przecina "+dot.toString());
                    dot.ticked=true;   
                }
                
            }
            
            Segment toAdd = new Segment(newEnd1,new Vector2D(mousePosX,mousePosY),2.0f * dotRadius);
            plane.segments.add(toAdd);
            
            if(blockGameArea == false && allDotsTicked() == true)
            {
                System.out.println("Blokujemy planszę!");
                 blockGameArea = true;
            }
               
        }
        
        
    }
    
    @Override
    public void mousePositionChanged(int posX, int posY)
    {
        mousePosX = posX;
        mousePosY = posY;
        
        if(blockGameArea == true) return;
        if(firstPoint == true)
        {
            plane.segments.get(plane.segments.size()-1).setEnd2Pos(mousePosX, mousePosY);
        }
    }

    protected Plane getPlane()
    {
        return plane;
    }
    
    @Override
    public void paint(Graphics g)
    {
        plane.paint(g);
    }
    
    @Override
    public int getInfo()
    {
        return Integer.max(0,plane.segments.size()-1);
    }

}
