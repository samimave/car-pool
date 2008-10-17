package car.pool.user.registration;

import java.util.LinkedList;
import java.util.List;

/**
 * Contains a list of strings that are used in the BlurredImage class as a means of safeguarding user registration
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class RandomTextGenerator {
	
	private List<String> list = new LinkedList<String>();//Collections.synchronizedList(new ArrayList<String>()); 
	
	public RandomTextGenerator() {
		String[] quotes = {"BLUE2", "4GREEN2D", "FROG51", "G2BNICE", "OGLE4U", "FL4W3D", "5HARPT", "IH3ART", "UST4RT", "M3ETME", "U4PWND", "B4SEAT","SOR3EY","BR3AKD","FR4AKD"};
		
		for(String quote : quotes) {
			this.list.add(quote);
		}
	}
	
	public String get(Integer pos) {
		return this.list.get(pos);
	}
	
	public void set(List<String> list) {
		this.list = list;
	}
	
	public void add(String quote) {
		this.list.add(quote);
	}
	
	public Integer size() {
		return this.list.size();
	}
}
