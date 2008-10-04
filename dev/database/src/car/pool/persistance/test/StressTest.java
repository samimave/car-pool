package car.pool.persistance.test;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Random;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.StoreException;

public class StressTest implements Runnable{

	static final int count = 5;
	Random r = new Random();
	String[] names = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k"};
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		runStress();
	}
	
	public static void runStress(){
		StressTest[] test = new StressTest[count];
		for(int i = 0;i<count;i++){
			StressTest st = new StressTest();
			test[i] = st;
			st.run();
		}
	}

	@Override
	public void run() {
		CarPoolStore cps = null;
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
		
		for(int ee = 0; ee < 1000; ee++){
			try {	
			addRandom();
			cps.findLocation(stringR());
			cps.addUser(names[r.nextInt(names.length)], stringR());
			cps.addUser(names[r.nextInt(names.length)], stringR());
			int a = cps.addUser(stringR(), stringR());
			int b = cps.addUser(stringR(), stringR());
			int c = cps.addUser(stringR(), stringR());
			cps.findLocation(stringR());
			int d = cps.addUser(stringR(), stringR());
			int e = cps.addUser(stringR(), stringR());
			int f = cps.addUser(stringR(), stringR());
			cps.addUser(names[r.nextInt(names.length)], stringR());
			int g = cps.addUser(stringR(), stringR());
			int h = cps.addUser(stringR(), stringR());
			int j = cps.addUser(stringR(), stringR());
			int i = cps.addUser(stringR(), stringR());
			int k = cps.addUser(stringR(), stringR());
			int l = cps.addUser(stringR(), stringR());
				
				
				Date date = new Date(System.currentTimeMillis());
				//addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int reoccur, String time, String comment)			
				int ride1 = cps.addRide(a, 4, date.toString(), idLocation, idLocation, 0, 0, "5:22 PM", "be on time");
				int ride2 = cps.addRide(b, 4, date.toString(), idLocation, idLocation,1, 0, "6:22 AM", "no latecomers please");
				int ride3 = cps.addRide(c, 4, date.toString(), idLocation, idLocation,2, 0, "3:22 PM", "I might be a few minutes late");
				int ride4 = cps.addRide(d, 4, date.toString(), idLocation, idLocation,3, 0, "9:22 PM", "be on time");
	//			int ride5 = cps.addRide(e, 4, date.toString(), "asgadfg", "adfgadfgafd home");
				cps.findLocation(stringR());
				cps.takeRide(e, ride1, idLocation,0);
				cps.takeRide(f, ride1, idLocation,0);
				cps.takeRide(g, ride1, idLocation,0);
				cps.takeRide(h, ride1, idLocation,0);
				cps.addUser(names[r.nextInt(names.length)], stringR());
				cps.takeRide(i, ride2, idLocation,0);
				cps.takeRide(j, ride2, idLocation,0);
				
				cps.takeRide(g, ride3, idLocation,0);
				cps.takeRide(h, ride3, idLocation,0);
				cps.findLocation(stringR());
				cps.takeRide(k, ride3, idLocation,0);
				cps.takeRide(l, ride4, idLocation,0);
				cps.addUser(names[r.nextInt(names.length)], stringR());
			} catch (Exception eee) {
				// TODO Auto-generated catch block
				eee.printStackTrace();
			}
		}
		CarPoolStoreImpl cpsi =(CarPoolStoreImpl)cps;
		cpsi.removeAll("donotusethis");
	}
	
	@SuppressWarnings("unused")
	private void addRandom() throws IOException, StoreException, SQLException{
		Date date = new Date(System.currentTimeMillis());
		CarPoolStore cps = new CarPoolStoreImpl();
		for(int i = 0; i < 100; i++){
			cps.addUser(Float.toString(r.nextFloat()),Float.toString(r.nextFloat()));
		}
		waitR();
		for(int i = 0; i < 100; i++){
			if(r.nextFloat()<0.2){
				int a = cps.addUser(stringR(),stringR());
				int b = cps.addUser(stringR(),stringR());
				cps.attachOpenID(stringR(), a);
				int re = cps.addRegion(stringR());
				cps.findLocation(stringR());
				int los = cps.addLocation(re, stringR());
				int loe = cps.addLocation(re, stringR());
				cps.attachOpenID(stringR(), a);
				int c = cps.addRide(a, 4, date.toString(), los, loe, r.nextInt(), 0, stringR(), stringR());
				cps.attachOpenID(stringR(), b);
			}else if(r.nextFloat()<0.4){
				int a = cps.addUser(stringR(),stringR());
				int b = cps.addUser(stringR(),stringR());
				int re = cps.addRegion(stringR());
				int los = cps.addLocation(re, stringR());
				int loe = cps.addLocation(re, stringR());
				int c = cps.addRide(a, 4, date.toString(), los, loe, r.nextInt(), 0, stringR(), stringR());
			}else if(r.nextFloat()<0.6){
				int a = cps.addUser(stringR(),stringR());
				int b = cps.addUser(stringR(),stringR());
				int re = cps.addRegion(stringR());
				int los = cps.addLocation(re, stringR());
				cps.findLocation(stringR());
				int loe = cps.addLocation(re, stringR());
				int c = cps.addRide(a, 4, date.toString(), los, loe, r.nextInt(), 0, stringR(), stringR());
			}else if(r.nextFloat()<0.8){
				int a = cps.addUser(stringR(),stringR());
				int b = cps.addUser(stringR(),stringR());
				int re = cps.addRegion(stringR());
				int los = cps.addLocation(re, stringR());
				int loe = cps.addLocation(re, stringR());
				int c = cps.addRide(a, 4, date.toString(), los, loe, r.nextInt(), 0, stringR(), stringR());
			}else{
				cps.findLocation(stringR());
				cps.findLocation(stringR());
				cps.findLocation(stringR());
			}
		}
	}
	
	@SuppressWarnings("static-access")
	private void waitR(){
		try {
			
			Thread.currentThread().sleep((long)(r.nextFloat()*50));
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private String stringR(){
		return Float.toString(r.nextFloat());
	}
	
	

}
