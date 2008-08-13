package car.pool.persistance;

import java.sql.Statement;

public interface Database {

	void connect();
	Statement getStatement();
}
