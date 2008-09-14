package car.pool.persistance;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DatabaseImpl implements Database{

	Connection connection;
	String url;
	String user;
	String password;
	
	public DatabaseImpl() throws IOException{
		Properties prop = new Properties();

			InputStream inStream = this.getClass().getClassLoader().getResourceAsStream("data.properties");
			if(inStream == null){
				prop.load(new FileInputStream("data.properties"));
			}else{
				prop.load(inStream);
			}
		
		setURL((String)prop.get("url"));
		setUser((String)prop.get("user"));
		setPassword((String)prop.get("password"));
		registerDriver();
	}
	
	public DatabaseImpl(String url, String user, String password) {
		
		this.url = url;
		this.user = user;
		this.password = password;
		
		registerDriver();
	}

	private void registerDriver(){
		// Register the JDBC driver for MySQL.
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void setURL(String url){
		this.url = url;
	}
	private void setUser(String user){
		this.user = user;
	}
	private void setPassword(String password){
		this.password = password;
	}
	
	public synchronized void connect() {

		try {
			if (connection == null || connection.isClosed()) {
				// Define URL of database server for
				// database named mysql on the localhost
				// with the default port number 3306.

				// Get a connection to the database for a
				// user named root with a blank password.
				// This user is the default administrator
				// having full privileges to do anything.
				try {
					
					connection = DriverManager.getConnection(url, user,
							password);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public synchronized Statement getStatement() {

		connect();
		Statement stmt = null;
		try {
			// Get a Statement object
			stmt = connection.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return stmt;
	}

}
