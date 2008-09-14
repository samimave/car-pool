package car.pool.locations;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Vector;

public class LocationImporter {
	public static String[] importLocations(){
		Vector<String> locations = new Vector<String>(200);
		
		
		try {
			FileReader fr = new FileReader("streets.txt");
			int i;
			StringBuffer sb = new StringBuffer();
			while(fr.ready() && (i=fr.read())!= -1){
				char c = (char)i;
				if(c == ','){
					locations.add(sb.toString().trim());
					sb.delete(0,sb.length());
				}else{
					sb.append(c);
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		return locations.toArray(new String[locations.size()]);
	}
	
	public static void main(String[] args) {
		for(String name : LocationImporter.importLocations() ) {
			System.out.println(name);
		}
	}
}
