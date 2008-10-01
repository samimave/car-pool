package car.pool.persistance;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserList {
	ResultSet rs = null;
	
	public UserList(Statement statement, boolean all){
		String sql = null;
		if(all){
			sql = "Select userName, email, mobile_number, signUpDate "+ "FROM User;";
		}
		
		try {
			rs = statement.executeQuery(sql);
		} catch (SQLException e) {
			System.out.println("sql:"+sql);
			e.printStackTrace();
		}
		
	}
	
	public boolean next() throws SQLException{
		return rs.next();
	}
	
	public String getUserName() throws SQLException{
		return rs.getString("userName");
		
	}
	
	public String getUserEmail() throws SQLException{
		return rs.getString("email");
		
	}
	
	public String getUserPhone() throws SQLException{
		return rs.getString("mobile_number");
		
	}
	
	public String getUserSignUpDate() throws SQLException{
		return rs.getString("signUpDate");
		
	}

}
