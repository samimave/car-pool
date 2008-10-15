package car.pool.persistance.test;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

import javax.swing.JOptionPane;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.StoreException;

public class TestSetup {
	
	private static CarPoolStore cps = null;
	
	public TestSetup(){
		try {
			cps = new CarPoolStoreImpl();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		try {
			int a = cps.addUser("a", "a");
			int b = cps.addUser("b", "b");
			int c = cps.addUser("c", "c");
			int d = cps.addUser("d", "d");
			int e = cps.addUser("e", "a");
			int f = cps.addUser("f", "b");
			int g = cps.addUser("g", "c");
			int h = cps.addUser("h", "d");
			int i = cps.addUser("i", "a");
			int j = cps.addUser("j", "b");
			int k = cps.addUser("k", "c");
			int l = cps.addUser("l", "d");
/*			int m = cps.addUser("m", "a");
			int n = cps.addUser("n", "b");
			int o = cps.addUser("o", "c");
			int p = cps.addUser("p", "d");
			int q = cps.addUser("q", "a");
			int r = cps.addUser("r", "b");
			int s = cps.addUser("s", "c");
			int t = cps.addUser("t", "d");
*/			
			Date date = new Date(System.currentTimeMillis());
			//addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int reoccur, String time, String comment)			
			int ride1 = cps.addRide(a, 4, date.toString(), idLocation, idLocation, 0, 0, "5:22 PM", "be on time");
			int ride2 = cps.addRide(b, 4, date.toString(), idLocation, idLocation,1, 0, "6:22 AM", "no latecomers please");
			int ride3 = cps.addRide(c, 4, date.toString(), idLocation, idLocation,2, 0, "3:22 PM", "I might be a few minutes late");
			int ride4 = cps.addRide(d, 4, date.toString(), idLocation, idLocation,3, 0, "9:22 PM", "be on time");
//			int ride5 = cps.addRide(e, 4, date.toString(), "asgadfg", "adfgadfgafd home");
			
			cps.takeRide(e, ride1, idLocation,0);
			cps.takeRide(f, ride1, idLocation,0);
			cps.takeRide(g, ride1, idLocation,0);
			cps.takeRide(h, ride1, idLocation,0);
			
			cps.takeRide(i, ride2, idLocation,0);
			cps.takeRide(j, ride2, idLocation,0);
			
			cps.takeRide(g, ride3, idLocation,0);
			cps.takeRide(h, ride3, idLocation,0);
			
			cps.takeRide(k, ride3, idLocation,0);
			cps.takeRide(l, ride4, idLocation,0);
			
		} catch (StoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void setup(){
//		TestSetup ts = new TestSetup();
	}
	
	public static void tearDown(){
		CarPoolStoreImpl psi = (CarPoolStoreImpl)cps;
		psi.removeAll("donotusethis");
	}
	
	public static void main(String[] args) {
		setup();
		System.out.println(("setup"));
		JOptionPane.showConfirmDialog(null, "Click to remove all from DB");
		tearDown();
		System.out.println("done.");
	}
}
