package pattern;
import java.util.regex.*;

import org.junit.*;
import static org.junit.Assert.*;
import java.util.LinkedList;
public class BallExtractorTest {



    @Test 
	public void problematicOne() {
	assertTrue(BallExtractor.isMatch("BP-10.4, 31.9V-0.66,-0.13= 0.63 BD-29.51,-31.74=43.34"));
	
    }
    @Test
	public void bigTester(){
	LinkedList ballList = new LinkedList();
	ballList.add("BP -1.4,  1.9V-1.30, 1.77= 2.06 BD-48.58,-1.86=48.61 kick");
	ballList.add("BP -3.8,  5.4V-1.04, 1.58= 1.78 BD-44.46,-5.50=44.80 ");
	ballList.add("BP -5.7,  8.5V-0.88, 1.44= 1.59 BD-40.44,-8.90=41.40 ");
	ballList.add("BP 28.8,  9.4V-1.25,-0.21= 1.19 BD-68.32,-10.17=69.08 ");
	ballList.add("BP  9.0,-28.7V 0.22,-0.46= 0.48 BD-49.02,28.55=56.73 ");
		
	for (int i = 0; i < ballList.size(); ++i) {	  
	    assertTrue(BallExtractor.isMatch((String)ballList.get(i)));
	}
   }
    @Test
	public void testBallPos(){
	BallExtractor ball = new BallExtractor("BP  9.0,-28.7V 0.22,-0.46= 0.48 BD-49.02,28.55=56.73 ");
	assertTrue(ball.getBallPosX() == 9.0);
	assertTrue(ball.getBallPosY() == -28.7);
    }

    @Test
	public void testBallVel(){
	BallExtractor ball = new BallExtractor("BP  9.0,-28.7V 0.22,-0.46= 0.48 BD-49.02,28.55=56.73 ");
	assertTrue(ball.getBallVelocityX() == 0.22);
	assertTrue(ball.getBallVelocityY() == -0.46);
    }

     @Test
	public void testBallDir(){
	BallExtractor ball = new BallExtractor("BP  9.0,-28.7V 0.22,-0.46= 0.48 BD-49.02,28.55=56.73 ");
	assertTrue(ball.getBallDirX() == 49.02);
	assertTrue(ball.getBallDirY() == 28.55);
    }

}