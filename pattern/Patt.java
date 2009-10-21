package pattern;
import java.util.LinkedList;
interface Patt {
    public boolean isMatch(String str);
    public Object bind(String str, Extractor ext) throws Exception;
}
    