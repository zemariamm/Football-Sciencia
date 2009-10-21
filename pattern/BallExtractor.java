package pattern;
import java.util.regex.*;
public class BallExtractor {
    String line;
    private static final String commaspace = ",[\\s]*";
    private static final String vspace = "V[\\s]*";
    private static final String equalspace = "=[\\s]*";
    private static final String univ = ".*";
    public static boolean isMatch(String str) {
	String reBP = "BP[\\s]*" + Util.floatrex + commaspace + Util.floatrex + vspace + Util.floatrex + commaspace + Util.floatrex + equalspace + Util.floatrex + "[\\s]*";
	String reBD = "BD[-]*"+Util.floatrex + commaspace + Util.floatrex + equalspace + Util.floatrex + ".*";
	return Pattern.matches(reBP + reBD,str);
    }

    public BallExtractor(String pline) {
	line = pline;
    }
    public double getBallPosX(){
	String pox = Util.inBetween(line,"BP[\\s]*",",.*");
	//System.out.println("PosX:" + pox);
	return Double.parseDouble(pox);
    }

    public double getBallPosY(){
	String poy = Util.inBetween(line,"BP[\\s]*" + Util.floatrex + commaspace,vspace + univ);
	//System.out.println("PosY:" + poy);
	return Double.parseDouble(poy);
    }


     public double getBallVelocityX(){
	String velx = Util.inBetween(line,univ + vspace ,commaspace + univ);
	//System.out.println("velx:" + velx);
	return Double.parseDouble(velx);
    }

    public double getBallVelocityY(){
	String vely = Util.inBetween(line,univ + vspace + Util.floatrex + commaspace,equalspace + univ);
	//System.out.println("velY:" + vely);
	return Double.parseDouble(vely);
    }

    public double getBallDirX(){
	String dirx = Util.inBetween(line,univ + "BD[-]*[\\s]*" ,commaspace + univ);
	//System.out.println("dirx:" + dirx);
	return Double.parseDouble(dirx);
    }

    public double getBallDirY(){
	String diry = Util.inBetween(line,univ + "BD[-]*[\\s]*" + Util.floatrex+commaspace ,equalspace + univ);
	//System.out.println("diry:" + diry);
	return Double.parseDouble(diry);
    }

}