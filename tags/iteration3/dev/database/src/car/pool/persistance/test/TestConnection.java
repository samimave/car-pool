package car.pool.persistance.test;

import java.io.IOException;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.StoreException;

public class TestConnection {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CarPoolStore cps = null;
		try {
			cps = new CarPoolStoreImpl();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
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
