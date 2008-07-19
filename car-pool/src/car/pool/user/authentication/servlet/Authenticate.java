package car.pool.user.authentication.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
			for(Enumeration<?> e = request.getParameterNames(); e.hasMoreElements() ; ) {
				String name = (String) e.nextElement();
				out.print("<p>");
				out.print(name);
				String[] values = request.getParameterValues(name);
				for(String value : values ) {
					out.print("&nbsp;");
					out.print(value);
				}
				out.print("</p>");
			}
			out.print("</p>");
			out.print("</body></html>");
			out.close();
		} catch (IOException e) {
//			e.printStackTrace();
		}
	}

	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processResponse(request, response);
	}   	  	    
}