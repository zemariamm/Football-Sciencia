package pattern;
import java.util.regex.*;
import java.util.LinkedList;
public class PlayerExtractor {
    String line;
    
    public PlayerExtractor(String pline){
	line = pline;
    }


    public static boolean isMatch(String str) {
	return Pattern.matches("Tm\\s[lr][\\s]+Pl[\\s]+[\\d]+.*",str);
    }
    public int getNumber(){
	String num = Util.inBetween(line,"Tm[\\s]+[lr][\\s]+Pl[\\s]+","[\\s]+.*");
	return Integer.parseInt(num);
    }

    public String getTeam() {
	String team = Util.inBetween(line,"Tm[\\s]+","[\\s]+Pl.*");
	return team;

    }

    public LinkedList getPlayerPos() {
	String coors = Util.inBetween(line,"Tm[\\s]+[rl][\\s]+Pl[\\s]+[\\d]+[\\s]+","[\\s]*d.*");
	//System.out.println(coors);
	String posx = Util.inBetween(coors,"P\\([\\s]*",",[\\s]*"+Util.floatrex + ".*");
	String posy = Util.inBetween(coors,"P\\([\\s]*" +Util.floatrex +",[\\s]*", "[\\s]*\\).*");
	LinkedList ans = new LinkedList();
	ans.add(0,Double.parseDouble(posx));
	ans.add(1,Double.parseDouble(posy));
	return ans;
    }

    public double getPlayerPosX() {
	LinkedList ans = getPlayerPos();
	Double x_obj = (Double) ans.get(0);
	double x = x_obj.doubleValue();
	return x;
    }
    public double getPlayerPosY() {
	LinkedList ans = getPlayerPos();
	Double y_obj = (Double) ans.get(1);
	double y = y_obj.doubleValue();
	return y;
    }

    public LinkedList getPlayerVelocity() {
	String velx = Util.inBetween(line,".*v\\([\\s]*",",.*");
	String vely = Util.inBetween(line,".*v\\([\\s]*" + Util.floatrex + ",[\\s]*","\\).*");
	//System.out.println("VELX:" + velx);
	//System.out.println("VELY:" + vely);
	LinkedList ans = new LinkedList();
	ans.add(0,Double.parseDouble(velx));
	ans.add(1,Double.parseDouble(vely));
	return ans;
    }

    public double getPlayerVelocityX() {
	LinkedList ans = getPlayerVelocity();
	Double velx_obj = (Double) ans.get(0);
	double velx = velx_obj.doubleValue();
	return velx;
    }

    public double getPlayerVelocityY() {
	LinkedList ans = getPlayerVelocity();
	Double vely_obj = (Double) ans.get(1);
	double vely = vely_obj.doubleValue();
	return vely;
    }
}