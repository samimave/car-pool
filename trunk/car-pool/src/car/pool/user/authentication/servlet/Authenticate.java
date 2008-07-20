package car.pool.user.authentication.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import car.pool.user.User;
import car.pool.user.database.UserRecordFetcher;

/**
 * Servlet implementation class for Servlet: Authenticate
 *
 */
 public class Authenticate extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
   static final long serialVersionUID = 1L;
   
    /* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public Authenticate() {
		super();
		
	}
	
	@Override
	public void init() throws ServletException {
		super.init();
		System.out.println("Authenticate init");
	}
	
//	@Override
//	public void init()
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processResponse(request, response);
	}  	

	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processResponse(request, response);
	}
	
	private void processResponse(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			PrintWriter out = response.getWriter();
			out.print("<html><head><title>Authenticate</title></head><body><p>Authentication is done here</p>");
			out.print("<p>");
			out.print(request.getMethod());
			out.print("</p>");
			
			out.print("<p>");
			String name = request.getParameter("name");
			String password = request.getParameter("password");
			UserRecordFetcher fetcher = new UserRecordFetcher();
			User record = fetcher.getUserRecord(name);
			if(record.getName().equals(name) && record.getPassword().equals(password)) {
				out.print("Welcome ");
				out.print(name);
			} else {
				out.print("Authentication failed");
			}
			out.print("</p>");
			out.print("</body></html>");
			out.close();
		} catch (IOException e) {
//			e.printStackTrace();
		}
	}
}
