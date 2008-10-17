package car.pool.proxy;

import java.net.Proxy;
import java.net.SocketAddress;

/**
 * Keeps the proxy class and any data associated witht that proxy 
 * @author terrasea
 *
 */
public class ProxyData {
	public SocketAddress address = null;
	public Proxy proxy = null;
	public Integer failedCount = new Integer(0);
	
	public ProxyData(SocketAddress address, Proxy proxy ) {
		this.address = address;
		this.proxy = proxy;
	}
	
	public ProxyData(SocketAddress address) {
		this.address = address;
		proxy = new Proxy(Proxy.Type.HTTP, address);
	}
}
