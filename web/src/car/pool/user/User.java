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
	
	/**
	 * For convenience instead of every time having to check all fileds for equality just doing it once with this method
	 * @param obj - the object to compare with
	 * @return true if both obj and the called on instance of User contain the same data, false otherwise
	 */
	@Override
	boolean equals(Object obj);
	
	
	/**
	 * If you override equals(obj) then you should override hashCode() as any object that equals another should return the same hasCode
	 * @return a integer representing the hash code of this object
	 */
	@Override
	int hashCode();
}
