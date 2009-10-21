package pattern;
import java.util.regex.*;

import org.junit.*;
import static org.junit.Assert.*;

public class TimeExtractorTest {
    TimeExtractor p;

    @Test 
	public void testisTime(){
	boolean val = TimeExtractor.isMatch("--------------------Time 4------------------");
	assertTrue(val);
    }


    @Test public void testtimeNuber(){
	TimeExtractor time = new TimeExtractor("--------------------Time 4------------------");
	assertTrue(time.getNumber() == 4);

    }

        @Test public void testtimeNuberBig(){
	TimeExtractor time = new TimeExtractor("--------------------Time 3500------------------");
	assertTrue(time.getNumber() == 3500);

    }
}