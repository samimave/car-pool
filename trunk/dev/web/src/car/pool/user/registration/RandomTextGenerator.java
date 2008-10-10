package car.pool.user.registration;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class RandomTextGenerator {
	private List<String> list = Collections.synchronizedList(new ArrayList<String>()); 
	public RandomTextGenerator() {
		String[] quotes = {"BLUE2", "4GREEN2D", "FROG5O", "G2BNICE", "OGLE4U"};
		for(String quote : quotes) {
			list.add(quote);
		}
	}
	
	public String get(Integer pos) {
		return list.get(pos);
	}
	
	public void set(List<String> list) {
		this.list = list;
	}
	
	public void add(String quote) {
		list.add(quote);
	}
	
	public Integer size() {
		return list.size();
	}
}
