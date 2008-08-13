package car.pool.user;

import java.util.Calendar;
import java.util.Set;

public interface User {
	Integer getUserId();
	void setUserId(Integer id);

	String getUserName();
	void setUserName(String name);

	Set<String> getOpenIds();
	void addOpenId(String openid);
	void delOpenId(String openid);

	String getName();
	void setName(String name);

	String getPassword();
	void setPassword(String password);

	String getPhoneNumber();
	void setPhoneNumber(String phone);
	
	String getEmail();
	void setEmail(String email);
	
	Integer getSocialScore();
	void setSocialScore(Integer score);
	
	Calendar getMemberSince();
	void setMemberSince(Calendar date);
	
	String getSuburb();
	void setSuburb(String suburb);
	
	String getOcupation();
	void setOcupation(String ocupation);
	
	// TODO find out what these are supposed to do and why a String for loginFailed()
	void editDetail();
	boolean loginFailed();
	boolean checkPassword();
	Integer calcSocialScore();
	
}
