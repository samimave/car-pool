package car.pool.persistance.test;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.DatabaseImpl;

public class TestConnection {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CarPoolStore cps = new CarPoolStoreImpl();
		
		int i = cps.addUser("john", "blah");
		System.out.println("result: "+i);
	}

}
