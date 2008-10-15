package car.pool.persistance.test;

import java.io.IOException;
import java.sql.SQLException;

import car.pool.locations.LocationImporter;
import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;

public class AddLocations {
	public static void main(String[] args) {
		String[] locations = LocationImporter.importLocations();
		
		CarPoolStore cps = null;
		
		try {
			cps = new CarPoolStoreImpl();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		int region = -1;
		
		try {
			region = cps.addRegion("Palmerston North");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		for(String street : locations){
			try {
				cps.addLocation(region, street);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
