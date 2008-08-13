package car.pool.user;


import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;

import java.io.IOException;

public class UserManager {

	public User login(String openid) throws InvaildUserNamePassword, IOException {
		return UserFactory.newInstance(openid);
	}
	

	public User registerUser(User user) throws DuplicateUserNameException, UserException, IOException {
		CarPoolStoreImpl store = new CarPoolStoreImpl();
		if(store.checkUserExists(user.getUserName())) {
			throw new DuplicateUserNameException("I have checked and you already exist");
		}
		int id = store.addUser((String)user.getOpenIds().toArray()[0], user.getUserName(), user.getEmail(), user.getPhoneNumber());
		for(String openid : user.getOpenIds()) {
			if(!((String)user.getOpenIds().toArray()[0]).equals(openid)) {
				store.attachOpenID(openid, id);
			}
		}
		
		user.setUserId(id);

		System.out.println("User ID: " + user.getUserId());		

		return user;
	}
	
	public User attachOpenId(String openid, User user) throws IOException {
		CarPoolStore store = new CarPoolStoreImpl();
		store.attachOpenID(openid, user.getUserId());
		user.addOpenId(openid);
		
		return user;
	}
	
	public boolean removeUser( User user ) throws IOException, StoreException {
		CarPoolStore store = new CarPoolStoreImpl();
		for(String openid : user.getOpenIds()) {
			System.out.println(openid);
			store.detachOpenID(openid,user.getUserId());
		}
		
		return store.removeUser(user.getUserName(), user.getPassword());
	}
}
