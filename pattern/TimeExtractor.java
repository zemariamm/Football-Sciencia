package pattern;
import java.util.regex.*;
public class TimeExtractor {
    String line;
    
    public TimeExtractor(String pline){
	line = pline;
    }


    public static boolean isMatch(String str) {
	return Pattern.matches("[-]+Time[\\s]+[\\d]+[-]+.*",str);
    }

    public int getNumber() {
	String num = Util.inBetween(line,"[-]+Time[\\s]+","[-]+.*");
	return Integer.parseInt(num);

    }


}