
package pattern;
import java.util.regex.*;
public class TeamExtractor implements Extractor{

    public TeamExtractor(){;}
    public Object extract(String str) throws Exception {
	/* DEBUG CODE
	   for (int i = 0;i< res.length; ++i)
	   System.out.println(res[i]);
	   DEBUG CODE */
	String resposta = inBetween(str,"Tm\\s","[\\s]+");
	System.out.println("The answer is:" + resposta);
	return resposta;
    }
    public String inBetween(String str, String rexg1,String rexg2) throws Exception{
	String [] resfirst = Pattern.compile(rexg1).split(str,0);

	/* // DEBUG CODE
	   for (int i = 0;i< resfirst.length; ++i)
	   System.out.println("DEBUG1: " + resfirst[i]);

	   //DEBUG END */


	if (resfirst.length < 1) {
	    throw new Exception("Problem with Pattern " + rexg1 + " length: " + resfirst.length); }
	String [] ressecond = Pattern.compile(rexg2).split(resfirst[1],0);

	/* DEBUG CODE

	   for (int i = 0;i< ressecond.length; ++i)
	   System.out.println("DEBUG2: " + ressecond[i]);
	   DEBUG END */
	
	if (ressecond.length != 1){
	    throw new Exception("Problem with Pattern" + rexg2);}
	return ressecond[0];
    }
}