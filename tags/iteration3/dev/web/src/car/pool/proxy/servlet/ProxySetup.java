package car.pool.proxy.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;
/**
 * designed to be used by ajax.  It's kept as simple as possible in terms of only outputing true or false to indicate if the operation was a success or not.
 * Needed to insert or delete proxy sever addresses as well as what type of proxy they are, thus making it possible to have many types of proxy server used in the site.
 * Currently only http or https is supported but in future more types of proxies maybe used.
 * @author terrasea
 *
 */
public class ProxySetup extends HttpServlet {
	private static final long serialVersionUID = 658412377370706669L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		response.setContentType("text/plain");
		if(request.getParameter("proxysetup") != null || request.getParameter("proxydelete") != null) {
			if(request.getParameter("ipaddress") != null && request.getParameter("port") != null && request.getParameter("ptypes") != null) {
				String ipaddress = request.getParameter("ipaddress");
				String port = request.getParameter("port");
				String ptypes = request.getParameter("ptypes");
				String sql = "";
				if(request.getParameter("proxysetup") != null) {
					sql = String.format("insert into proxyaddress values('%s','%s','%s');", ipaddress, port, ptypes);
				} else if(request.getParameter("proxydelete") != null) {
					sql = String.format("delete from proxyaddress where ipaddress='%s' and port='%s' and ptypes='%s';", ipaddress, port, ptypes);
				}
				Database db = new DatabaseImpl();
				try {
					if(db.getStatement().executeUpdate(sql) < 1) {
						// update failed
						System.out.println("Failed updating affected less than one row");
						out.print("false");
					} else {
						// update succeeded
						out.print("true");
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					// something is wrong with the sql or something
					out.print("false");
				}
			} else {
				System.out.println("wrong param names used");
				out.print("false");
			}			
		} else {
			// didn't identify itself properly.  This way ensures that the callers think about the data they send this servlet
			System.out.println("didn't id itself");
			out.print("false");
		}
		
		out.close();
	}
}
