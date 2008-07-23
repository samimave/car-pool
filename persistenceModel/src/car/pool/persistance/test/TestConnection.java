package car.pool.persistance.test;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.DatabaseImpl;
import car.pool.persistance.exception.StoreException;

public class TestConnection {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CarPoolStore cps = new CarPoolStoreImpl();
		try {
			
		int i = cps.addUser("john", "blah");
		System.out.println("result: "+i);
		
		i = cps.checkUser("john", "blah");
		System.out.println("result: "+i);
		
		}catch (StoreException e){
			e.printStackTrace();
			System.exit(0);
		}
		
		
	}

}
