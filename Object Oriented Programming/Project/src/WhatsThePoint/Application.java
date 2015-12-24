package WhatsThePoint;

import java.awt.Component;
import java.awt.event.WindowEvent;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;


public class Application extends JFrame
{
    static Application instance = null;
    
    final static int FRAME_WIDTH = 800;
    final static int FRAME_HEIGHT = 600;
    final static int SEC = 100;
    final static int FPS = 60;
    
    Model model,newModel;
    View view,newView;
    
    public boolean shouldExit;
    public boolean shouldChangeState;
    
    Application()
    {
        model = null;
        view = null;
        shouldExit = false;
        shouldChangeState = false;
    }
    
    public static Application getInstance()
    {
        if(instance == null) instance = new Application();
        return instance;
    }
    
    public void initialize()
    {
        setTitle("Projekt z PO");
        setSize(FRAME_WIDTH, FRAME_HEIGHT);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        
        changeState(new MainMenuModel(),new MainMenuView());
        setVisible(true);
    }
    
    public void changeState(Model newModel, View newView)
    {
        this.getContentPane().removeAll();
        //this.revalidate();
        //this.repaint();
        
        model = newModel;
        view = newView;
        
        view.setModel(model);
        model.setView(view);
        
        model.initialize();
        view.initialize();
        
        this.add(view);
        this.revalidate();
        this.repaint();
        shouldChangeState = false;
    }
    
    public void run()
    {
        while(shouldExit == false)
        {
            //System.out.println("Jestem w "+view.getClass().getName());
            //controller.handleInput();
            model.update();
            view.repaint();
            
            if(shouldChangeState)changeState(newModel, newView);
            
            try
            {
                Thread.sleep(SEC/FPS);
            } catch (InterruptedException ex) {
                Logger.getLogger(Application.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        System.out.println("terminated");
    }
    
    public void exit()
    {
        shouldExit = true;
    }
    
    public void setNewState(Model m,View v)
    {
        newModel = m;
        newView = v;
        shouldChangeState = true;
    }
    
    public void cleanup()
    {
        setVisible(false);
        dispose();
    }
}
