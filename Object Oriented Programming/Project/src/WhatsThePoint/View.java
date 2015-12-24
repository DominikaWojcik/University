package WhatsThePoint;

import javax.swing.JPanel;


public class View extends JPanel
{
    Model model;
    
    View()
    {
        model=null;
    }
    
    View(Model model)
    {
        this.model = model;
    }
    
    public Model getModel()
    {
        return model;
    }
    
    public void setModel(Model model)
    {
        this.model=model;
    }
    
    public void initialize()
    {
        
    }
    
    public void showSpecialDialog()
    {
        
    }
 
}
