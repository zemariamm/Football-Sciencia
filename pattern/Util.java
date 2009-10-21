package pattern;
import java.util.regex.*;

//import org.junit.*;
//import static org.junit.Assert.*;

public class Util {

    public static final String floatrex = "[-]*[\\d]+\\.[\\d]+";
    public static  String inBetween(String str,String rex1, String rex2) {
	Pattern patst = Pattern.compile(rex1);
	Matcher matst = patst.matcher(str);
	str = matst.replaceAll("");
	Pattern patsd = Pattern.compile(rex2);
	Matcher matsd = patsd.matcher(str);
	str = matsd.replaceAll("");
	return str;
    }
    /*
    @Test
	public void equals() {
	assertTrue(inBetween("--------------------Time 2------------------","[-]+Time\\s","[-]+").equals("2"));
    }

    @Test
	public void shouldBeDifferent() {
	assertFalse(inBetween("Time 2---------","[-]+Time\\s","[-]+").equals("2"));
    }

    @Test
	public void team(){
	assertTrue(inBetween("Tm r Pl 10","Tm[\\s]+","[\\s]+Pl.*").equals("r"));

    }

    
    @Test
	public void playerNumber(){
	String num = inBetween("Tm r Pl 10 ","Tm[\\s]+[lr][\\s]+Pl[\\s]+","[\\s]+.*");
	//System.out.println("Number is:" + num);
	assertTrue(num.equals("10"));

    }

    @Test
	public void playerCoor(){
	String coors = inBetween("Tm r Pl  8 P(  1.5, 16.0) d","Tm[\\s]+[rl][\\s]+Pl[\\s]+[\\d]+[\\s]+","[\\s]*d");
	assertTrue(coors.equals("P(  1.5, 16.0)"));
    }


    @Test public void floatsRex(){
	assertTrue(Pattern.matches(floatrex,"1.5"));
	assertTrue(Pattern.matches(floatrex,"17.1"));
	assertTrue(Pattern.matches(floatrex,"0.0"));
	assertTrue(Pattern.matches(floatrex,"-20.0"));
    }
    @Test
	public void playerCoorExtensive(){
	String coors = inBetween("Tm r Pl  8 P(  1.5, 16.0) d","Tm[\\s]+[rl][\\s]+Pl[\\s]+[\\d]+[\\s]+","[\\s]*d");
	assertTrue(coors.equals("P(  1.5, 16.0)"));
	
    }
    
    
    @Test
	public void playerPosition(){
	String coors = inBetween("Tm r Pl  8 P(  1.5, 16.0) d","Tm[\\s]+[rl][\\s]+Pl[\\s]+[\\d]+[\\s]+","[\\s]*d.*");
	assertTrue(coors.equals("P(  1.5, 16.0)"));
	String posx = inBetween(coors,"P\\([\\s]*",",[\\s]*"+floatrex + ".*");
	assertTrue("Error posx:" + posx + " != " + "1.5",posx.equals("1.5"));
	String posy = inBetween(coors,"P\\([\\s]*" +floatrex +",[\\s]*", "[\\s]*\\).*");
	assertTrue("Error posy:" + posy + " != " + "16.0",posy.equals("16.0"));
    }

    @Test
	public void playerAngle(){
	String playerangle = ".*" +floatrex + "[\\s]*\\)[\\s]*d[\\s]*";
	String playerangleclose = "[\\s]*v\\(.*";
	String angle = inBetween("Tm l Pl  1 P(-50.5,  0.0) d -0 v( 0.00, 0.00)",playerangle,playerangleclose);
	assertTrue("Angle should be -0",angle.equals("-0"));
    }

    @Test
	public void playerVelocity() {
	String velx = inBetween("Tm l Pl  1 P(-50.5,  0.0) d -0 v( 0.00, 0.00) tp0 hd_a -5",".*v\\([\\s]*",",.*");
	assertTrue("Velocity X should be 0.00",velx.equals("0.00"));
	String vely = inBetween("Tm l Pl  1 P(-50.5,  0.0) d -0 v( 0.00, 0.00) tp0 hd_a -5",".*v\\([\\s]*" + floatrex + ",[\\s]*","\\).*");
	assertTrue("Velocity Y should be 0.00",vely.equals("0.00"));

    }

    */

    /*
    public static void main(String[] args) {
	String res = inBetween("--------------------Time 2------------------","[-]+Time\\s","[-]+");
	System.out.println("O resultado e:" + res);
    }
    */

}