package pattern;
import java.util.LinkedList;
import java.util.regex.*;
public class PattImpl implements Patt {

    private String regx;
    public PattImpl(String aregx) {
	regx = aregx;
    }

    public boolean isMatch(String str) {
	return Pattern.matches(regx,str);
    }

    public Object bind(String str, Extractor ext) throws Exception {
	LinkedList ans = new LinkedList();
	ans.add(ext.extract(str));
	return ans;
    }
}