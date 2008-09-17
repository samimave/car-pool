package car.pool.proxy;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.SocketAddress;
import java.net.URI;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

public class ProxyConfig extends ProxySelector {

	// A reference to the old ProxySelector
	ProxySelector defsel = null;
	/*
	 * A list of proxies, indexed by their address.
	 */
	Map<SocketAddress,ProxyData> proxies = Collections.synchronizedMap(new Hashtable<SocketAddress, ProxyData>());
	
	public ProxyConfig(ProxySelector def) {
		defsel = def;
		setProxies();
		System.out.format("ProxyConfig with proxies: %s\n", proxies.toString());
	}
	
	private void setProxies() {
		SocketAddress addr = new InetSocketAddress("tur-cache1.massey.ac.nz", 8080);
		ProxyData data = new ProxyData(addr);
		proxies.put(addr, data);
		addr = new InetSocketAddress("tur-cache2.massey.ac.nz", 8080);
		data = new ProxyData(addr);
		proxies.put(addr, data);
	}
	
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
			System.out.format("count: %d\n", p.failedCount);
			/*
			 * It's one of ours, if it failed more than 3 times
			 * let's remove it from the list.
			 */
			if (p.failedCount >= 3) {
				proxies.remove(sa);
			} else {
				p.failedCount++;
			}
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
		if ("http".equalsIgnoreCase(protocol) ||
			"https".equalsIgnoreCase(protocol)) {
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
