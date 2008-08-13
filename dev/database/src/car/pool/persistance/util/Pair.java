package car.pool.persistance.util;

public class Pair<J, K> {

	public J first;
	public K second;
	
	public Pair(J f, K s){
		first = f;
		second = s;
	}
	
	@Override
	public String toString(){
		return first.toString()+" "+second.toString();
	}
}
