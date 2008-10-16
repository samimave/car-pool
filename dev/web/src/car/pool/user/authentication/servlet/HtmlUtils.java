package car.pool.user.authentication.servlet;

/**
 * A set of static methods useful across several classes for producing html output and other things like parameters for a query string
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class HtmlUtils {

	/**
	 * Generates a signin form for OpenID logins
	 * @param localAddr - the uri to be put in the action part of the form
	 * @param method - what method to use, post or get
	 * @return a string with the html tags needed to create a form
	 */
	public static String generateSigninForm(String localAddr, String method) {
		StringBuffer buff = new StringBuffer();
		buff.append("<form class=\"login\" name=\"openid_identifier\" action=\"");
		buff.append(localAddr);
		buff.append("\" method=\"");
		buff.append(method);
		buff.append("\"><p><input type=\"hidden\" name=\"signin\" value=\"true\"/>Your OpenId<input type=\"text\" name=\"openid_url\" id=\"openid_url\" size=\"30\"/><input type=\"submit\" value=\"Login\"/></p></form>");
		
		return buff.toString();
	}
	
	/**
	 * A form for logging out with.
	 * @param localAddr - the uri to be put in the action part of the form
	 * @param method - what method to use, post or get
	 * @return a string with the html tags needed to create a form
	 */
	public static String generateSignoutForm(String localAddr, String method) {
		StringBuffer buff = new StringBuffer();
		buff.append("<form class=\"logout\" action=\"");
		buff.append(localAddr);
		buff.append("\" method=\"");
		buff.append(method);
		buff.append("\"><p><input type=\"hidden\" name=\"signout\" value=\"true\"/><input type=\"submit\" value=\"Loggout\"/></p></form>");
		
		return buff.toString();
	}
	
	
	/**
	 * Produces a parameter string which can be used as part of a query string
	 * @param key - the parameter key that ids the parameter
	 * @param entry - the contents referenced by the key
	 * @return - a string like this key=entry with the entry formatted in such a way that any spaces will be replaced by %20
	 */
	public static String createParameterString(String key, String entry) {
		entry = entry.replace(" ", "%20"); // more maybe need to be replaced than just spaces
		return String.format("%s=%s", key, entry);
	}

}
