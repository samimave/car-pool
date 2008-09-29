package car.pool.persistance.test;

import java.io.IOException;

import car.pool.persistance.CarPoolStoreImpl;

public class removeAll {
	public static void main(String[] args) {
		CarPoolStoreImpl c = null;
		try {
			c = new CarPoolStoreImpl();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		c.removeAll("donotusethis");
	}
}
