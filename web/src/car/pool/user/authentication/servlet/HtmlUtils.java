package car.pool.user.authentication.servlet;

public class HtmlUtils {

	public static String generateSigninForm(String localAddr, String method) {
		StringBuffer buff = new StringBuffer();
		buff.append("<form class=\"login\" name=\"openid_identifier\" action=\"");
		buff.append(localAddr);
		buff.append("\" method=\"");
		buff.append(method);
		buff.append("\"><p><input type=\"hidden\" name=\"signin\" value=\"true\"/>Your OpenId<input type=\"text\" name=\"openid_url\" id=\"openid_url\" size=\"30\"/><input type=\"submit\" value=\"Login\"/></p></form>");
		
		return buff.toString();
	}
	
	public static String generateSignoutForm(String localAddr, String method) {
		StringBuffer buff = new StringBuffer();
		buff.append("<form class=\"logout\" action=\"");
		buff.append(localAddr);
		buff.append("\" method=\"");
		buff.append(method);
		buff.append("\"><p><input type=\"hidden\" name=\"signout\" value=\"true\"/><input type=\"submit\" value=\"Loggout\"/></p></form>");
		
		return buff.toString();
	}

}
