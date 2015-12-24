/**
 *
 * @author Dziku
 */
public class Main2 {
    public static void main(String[] args)
    {
        Bufor<Integer> bufor = new Bufor<Integer>(20);
        
        System.out.println("Stworzyłem bufor");
        
        Konsument konsument = new Konsument(bufor);
        System.out.println("Konsument stworzony");
        Producent producent = new Producent(bufor);
        System.out.println("Producent stworzony");
        
        System.out.println("Uruchamiamy wątki");
        producent.start();
        konsument.start();
    }
}
