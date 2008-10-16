package car.pool.user;

import java.util.Calendar;
import java.util.Set;
/**
 * Represents a user on the system with various setters and getters to retrieve their details with.
 * @author James Hurford <terrasea@gmail.com>
 *
 */
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
}
