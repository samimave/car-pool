package car.pool.locations;

import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.util.Formatter;
import java.util.Vector;

public class LocationImporter {
	protected LocationImporter() {
		
	}
	
	private Vector<String> getStreetsFromResource() {
		Vector<String> locations = new Vector<String>(200);
		InputStream inStream = this.getClass().getClassLoader().getResourceAsStream("streets.txt");
		int b = 0;
		StringBuilder text = new StringBuilder();
		try {
			while((b = inStream.read()) != -1) {
				char c = (char)b;
				text.append(c);
			}
			String[] streets = text.toString().split(",");
			for(String name: streets) {
				locations.add(name.trim());
			}
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		return locations;
	}
	
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
			locations = new LocationImporter().getStreetsFromResource();
		}
		
		
		
		return locations.toArray(new String[locations.size()]);
	}
	
	public static void main(String[] args) {
		for(String name : LocationImporter.importLocations() ) {
			System.out.println(name);
		}
	}
}
