package car.pool.user;

import java.util.Calendar;
import java.util.List;

public interface User {
	Integer getUserId();
	//void setUserId(Integer id);

	String getUserName();
	//void setUserName(String name);

	List<String> getOpenIds();
	//void addOpenId(String openid);

	String getName();
	//void setName(String name);

//	String getPassword();
//	String setPassword();

	String getPhoneNumber();
	String getEmail();
	Integer getSocialScore();
	Calendar memberSince();
	String getSuburb();
	String getOcupation();
	
	// TODO find out what these are supposed to do and why a String for loginFailed()
	void editDetail();
	boolean loginFailed();
	boolean checkPassword();
	Integer calcSocialScore();
	
}
