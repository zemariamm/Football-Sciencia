import java.io.*;
import java.util.Arrays;
import java.util.StringTokenizer;
import java.util.regex.*;
import pattern.*;
class LogReader {

    boolean gameStarted;
    public LogReader() {
	gameStarted = false;
    }

    public static void main(String []args) {
	String str;
	LogReader reader = new LogReader();
	try {
	    BufferedReader in = new BufferedReader(new FileReader("newteste.txt"));
	    //int i = 0;
	    while ((str = in.readLine()) != null) {
		if (TimeExtractor.isMatch(str)) {
		    TimeExtractor timer = new TimeExtractor(str);
		    reader.processTime(str);
		}
		else if (PlayerExtractor.isMatch(str)) {
		    reader.processPlayer(str);
		}
		else if (BallExtractor.isMatch(str)) {
		    reader.processBall(str);
		}
		else {
		    throw new Exception("INVALID LINE:" + str);

		}
	    }
	}catch(Exception e) {System.out.println(e);}
    }


    public void processTime(String str) {
	gameStarted = true;

    }
    public void processPlayer(String str){
	if (gameStarted) {
	    PlayerExtractor oplayer = new PlayerExtractor(str);
	    String bigone = "Team:" + oplayer.getTeam() + " number:" + oplayer.getNumber() + " position:" + oplayer.getPlayerPosX() + ":" + oplayer.getPlayerPosY() + " velocity:" + oplayer.getPlayerVelocityX() + ":" + oplayer.getPlayerVelocityY();
	    System.out.println(bigone);
	}
    }
    public void processBall(String str) {
	if (gameStarted) {
	    System.out.println(str);
	}
    }
}
    
