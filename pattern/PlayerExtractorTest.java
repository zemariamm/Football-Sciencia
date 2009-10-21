package pattern;
import java.util.regex.*;

import org.junit.*;
import static org.junit.Assert.*;

public class PlayerExtractorTest {
    PlayerExtractor p;



    @Test 
	public void testisPlayer(){
	boolean val = PlayerExtractor.isMatch("BP -1.4,  1.9V-1.30, 1.77= 2.06 BD-48.58,-1.86=48.61 kick");
	assertTrue(!val);
    }

    @Test 
	public void testisPlayerTime(){
	boolean val = PlayerExtractor.isMatch("--------------------Time 4------------------");
	assertTrue(!val);
    }


    @Test 
	public void testisPlayerBall(){
	boolean val = PlayerExtractor.isMatch("Tm l Pl  1 P(-49.1, -0.0) d -0 v( 0.35,-0.01) tp0 hd_a  2 (v_w 45/v_q1.0) st3890.00/ef1.000/rc1.0 Comm:dash say tneck");
	assertTrue(val);
    }

    @Test
    public void testgetNumber(){
	p = new PlayerExtractor("Tm l Pl  1 P(-49.1, -0.0) d -0 v( 0.35,-0.01) tp0 hd_a  2 (v_w 45/v_q1.0) st3890.00/ef1.000/rc1.0 Comm:dash say tneck");
	assertTrue(1 == p.getNumber());
    }
    

        @Test
    public void testgetTeam(){
	p = new PlayerExtractor("Tm l Pl  1 P(-49.1, -0.0) d -0 v( 0.35,-0.01) tp0 hd_a  2 (v_w 45/v_q1.0) st3890.00/ef1.000/rc1.0 Comm:dash say tneck");
	//System.out.println("Team:" + p.getTeam());
	assertTrue("l".equals(p.getTeam()));
    }


    @Test
	public void testgetPosition(){
	p = new PlayerExtractor("Tm l Pl  1 P(-49.1, -0.0) d -0 v( 0.35,-0.01) tp0 hd_a  2 (v_w 45/v_q1.0) st3890.00/ef1.000/rc1.0 Comm:dash say tneck");
	java.util.LinkedList ans = p.getPlayerPos();
	assertTrue(ans.size() == 2);
	Double x_obj = (Double) ans.get(0);
	double x = x_obj.doubleValue();
	Double y_obj = (Double) ans.get(1);
	double y = y_obj.doubleValue();
	assertTrue(x == -49.1);
	assertTrue(y == -0.0);
    }

     @Test
	public void testgetVelocity(){
	p = new PlayerExtractor("Tm l Pl  1 P(-49.1, -0.0) d -0 v( 0.35,-0.01) tp0 hd_a  2 (v_w 45/v_q1.0) st3890.00/ef1.000/rc1.0 Comm:dash say tneck");
	java.util.LinkedList ans = p.getPlayerVelocity();
	assertTrue(ans.size() == 2);
	Double velx_obj = (Double) ans.get(0);
	double velx = velx_obj.doubleValue();
	Double vely_obj = (Double) ans.get(1);
	double vely = vely_obj.doubleValue();
	assertTrue(velx == 0.35);
	assertTrue(vely == -0.01);
    }



}


