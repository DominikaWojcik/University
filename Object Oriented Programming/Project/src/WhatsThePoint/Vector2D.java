package WhatsThePoint;

import java.io.Serializable;


public class Vector2D implements Serializable
{
    public float x,y;
    
    public Vector2D()
    {
        x=y=0;
    }
    public Vector2D(float x, float y)
    {
        this.x = x;
        this.y = y;
    }
    
    public static Vector2D add(Vector2D a, Vector2D b)
    {
        return new Vector2D(a.x+b.x,a.y+b.y);
    }
    
    public static Vector2D sub(Vector2D a, Vector2D b)
    {
        return new Vector2D(a.x-b.x,a.y-b.y);
    }
    
    public void add(Vector2D b)
    {
        x+=b.x;
        y+=b.y;
    }
    
    public void sub(Vector2D b)
    {
        x-=b.x;
        y-=b.y;
    }
    public static Vector2D mul (float f, Vector2D a)
    {
        return new Vector2D(a.x * f, a.y * f);
    }
    
    public static Vector2D div ( Vector2D a, float f)
    {
        try
        {
            if(Float.compare(f, 0) == 0)throw new IllegalArgumentException();
            return new Vector2D(a.x/f,a.y/f);
        }
        catch(IllegalArgumentException e)
        {
            return new Vector2D();
        }
    }
    
    public float length()
    {
        return (float)Math.sqrt(x * x + y * y);
    }

    public static float distance(Vector2D a,Vector2D b)
    {
        return sub(a,b).length();
    }

    public static float scalarProduct(Vector2D a, Vector2D b)
    {
        return a.x * b.x + a.y * b.y;
    }

    public static float vectorProduct(Vector2D a, Vector2D b)
    {
        return a.x * b.y - a.y * b.x;
    }

    public static Vector2D projectToLin(Vector2D toProject, Vector2D a)
    {
        Vector2D ortonormal = div(a,a.length());
        //System.out.println("Ortonormal of "+a.toString()+" = "+ortonormal.toString());
        //System.out.println("Scalar product of ortonormal and toproject = "+Float.toString(scalarProduct(ortonormal,toProject)));
        return mul(scalarProduct(ortonormal, toProject) ,ortonormal);
    }

    public static boolean sameDirection(Vector2D a, Vector2D b)
    {
        return Math.signum(a.x) == Math.signum(b.x) && Math.signum(a.y) == Math.signum(b.y);
    }

    public static float distanceToLin(Vector2D v, Vector2D a)
    {
        return distance(projectToLin(v, a),v);
    }
    
    @Override
    public String toString()
    {
        return "("+ Float.toString(x)+", "+Float.toString(y)+")";
    }

}
