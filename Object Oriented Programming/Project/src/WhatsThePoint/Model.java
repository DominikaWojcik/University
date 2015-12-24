package WhatsThePoint;

import java.awt.Graphics;


public class Model 
{
    int mousePosX,mousePosY;
    View view;
    
    public Model()
    {
        
    }
    
    public void update()
    {
        
    }
    
    public void setView(View view)
    {
        this.view = view;
    }
    
    public View getView()
    {
        return view;
    }
    
    public void mouseClicked()
    {
        
    }
    
    public void mousePositionChanged(int posX, int posY)
    {
        mousePosX = posX;
        mousePosY = posY;
    }
    
    public void initialize()
    {
        
    }
    
    public void paint(Graphics g)
    {
        
    }
    
    public int getInfo()
    {
        return 0;
    }
}
