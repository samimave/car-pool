package car.pool.user;


import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.UserException;

public class UserManager {

	public User login(String openid) throws InvaildUserNamePassword {
		return UserFactory.getInstance(openid);
	}
	
	public void registerUser(User user) throws DuplicateUserNameException, UserException {
		CarPoolStoreImpl store = (CarPoolStoreImpl)CarPoolStoreImpl.getStore();
		
		int id = store.addUser(user.getUserName(), user.getEmail(), user.getPhoneNumber(),"");
		for(String openid : user.getOpenIds()) {
			store.attachOpenID(openid, id);
		}
	}
	
	
}
