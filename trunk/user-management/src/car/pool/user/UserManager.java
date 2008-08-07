package car.pool.user;


import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.UserException;

import java.io.IOException;

public class UserManager {

	public User login(String openid) throws InvaildUserNamePassword, IOException {
		return UserFactory.getInstance(openid);
	}
	
	public User registerUser(User user) throws DuplicateUserNameException, UserException, IOException {
		CarPoolStoreImpl store = new CarPoolStoreImpl();
		
		int id = store.addUser(user.getUserName(), user.getEmail(), user.getPhoneNumber(),"");
		for(String openid : user.getOpenIds()) {
			store.attachOpenID(openid, id);
		}
		
		user.setUserId(id);
		
		return user;
	}
	
	public User attachOpenId(String openid, User user) throws IOException {
		CarPoolStore store = new CarPoolStoreImpl();
		store.attachOpenID(openid, user.getUserId());
		user.addOpenId(openid);
		
		return user;
	}
}
