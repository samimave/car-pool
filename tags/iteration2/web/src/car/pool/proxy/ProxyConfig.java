package car.pool.proxy;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.SocketAddress;
import java.net.URI;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

public class ProxyConfig extends ProxySelector {

	// A reference to the old ProxySelector
	ProxySelector defsel = null;
	/*
	 * A list of proxies, indexed by their address.
	 */
	Map<SocketAddress,ProxyData> proxies = Collections.synchronizedMap(new Hashtable<SocketAddress, ProxyData>());
	
	public ProxyConfig(ProxySelector def) throws IOException, SQLException {
		defsel = def;
		setProxies();
		System.out.format("ProxyConfig with proxies: %s\n", proxies.toString());
	}
	
	/**
	 * run at startup to determine from a database what addresses to add to the list of proxies.
	 * @throws IOException when connection fails to the database
	 * @throws SQLException when a error hapens in the sql transaction run by this method
	 */
	private void setProxies() throws IOException, SQLException {
		Database db = new DatabaseImpl();
		Statement stmnt = db.getStatement();
		String sql = "SELECT ipaddress,port,ptypes FROM proxyaddress;";
		ResultSet rs = stmnt.executeQuery(sql);
		while(rs.next()) {
			String addr = rs.getString(1);
			Integer port = rs.getInt(2);
			String[] types = rs.getString(3).split(",");
			for(String type : types) {
				SocketAddress address = new InetSocketAddress(addr, port);
				if(type.equalsIgnoreCase("http") || type.equalsIgnoreCase("https")) {
					proxies.put(address, new ProxyData(address));
				} else if( type.equalsIgnoreCase("direct") ) {
					proxies.put(address, new ProxyData(address, new Proxy(Proxy.Type.DIRECT, address)));
				} else if(type.toLowerCase().matches("^socks.*")) {
					proxies.put(address, new ProxyData(address, new Proxy(Proxy.Type.SOCKS, address)));
				} else {
					System.out.format("ProxyConfig: wanted address: %s:%d.  %s is not a recognised type\n", addr,port,type);
				}
			}
			//Proxy.Type.DIRECT; Proxy.Type.HTTP; Proxy.Type.SOCKS;
		}
		//SocketAddress addr = new InetSocketAddress("tur-cache1.massey.ac.nz", 8080);
		//ProxyData data = new ProxyData(addr);
		//proxies.put(addr, data);
		//addr = new InetSocketAddress("tur-cache2.massey.ac.nz", 8080);
		//data = new ProxyData(addr);
		//proxies.put(addr, data);
	}
	
	/**
	 * public method for adding a proxy to the proxies table
	 * @param addr the aocket address to add of the proxy
	 * @param p the proxy object to add
	 */
	public void addProxy(SocketAddress addr, ProxyData p) {
		proxies.put(addr, p);
	}

	/*
	 * Method called by the handlers when it failed to connect
	 * to one of the proxies returned by select().
	 */
	@Override
	public void connectFailed(URI uri, SocketAddress sa, IOException ioe) {
		if (uri == null || sa == null || ioe == null) {
			throw new IllegalArgumentException("Arguments can't be null.");
		}
		System.out.format("ProxyConfig.connectFailed: uri = %s\n", uri.toString());
		/*
		 * Let's lookup for the proxy 
		 */
		ProxyData p = proxies.get(sa); 
		if (p != null) {
			
			/*
			 * It's one of ours, if it failed more than 3 times
			 * let's remove it from the list.
			 */
			if (p.failedCount >= 3) {
				proxies.remove(sa);
			} else {
				p.failedCount++;
			}
			System.out.format("count: %d\n", p.failedCount);
		} else {
			/*
			 * Not one of ours, let's delegate to the default.
			 */
			if (defsel != null) {
				defsel.connectFailed(uri, sa, ioe);
			}
		}
	}

	/*
	 * This is the method that the handlers will call.
	 * Returns a List of proxy.
	 */
	@Override
	public List<Proxy> select(URI uri) {
		if (uri == null) {
			throw new IllegalArgumentException("URI can't be null.");
		}
		
		System.out.format("ProxyConfig.select: uri = %s\n", uri.toString());
		
		String protocol = uri.getScheme();
		if (("http".equalsIgnoreCase(protocol) ||
			"https".equalsIgnoreCase(protocol) ) && proxies.size() > 0) {
			ArrayList<Proxy> l = new ArrayList<Proxy>();
			for(ProxyData d: proxies.values()) {
				l.add(d.proxy);
			}
			return l;
		}
		if (defsel != null) {
			return defsel.select(uri);
		} else {
			ArrayList<Proxy> l = new ArrayList<Proxy>();
			l.add(Proxy.NO_PROXY);
			return l;
		}
	}

}
