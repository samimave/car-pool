package car.pool.persistance;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

/**
* This code was edited or generated using CloudGarden's Jigloo
* SWT/Swing GUI Builder, which is free for non-commercial
* use. If Jigloo is being used commercially (ie, by a corporation,
* company or business for any purpose whatever) then you
* should purchase a license for each developer using Jigloo.
* Please visit www.cloudgarden.com for details.
* Use of Jigloo implies acceptance of these licensing terms.
* A COMMERCIAL LICENSE HAS NOT BEEN PURCHASED FOR
* THIS MACHINE, SO JIGLOO OR THIS CODE CANNOT BE USED
* LEGALLY FOR ANY CORPORATE OR COMMERCIAL PURPOSE.
*/
public class LocationList {

	ResultSet rs = null;
	static private JTextField jTextField1;
	static private JScrollPane jScrollPane1;
	static private JTextArea jTextArea1;

	public LocationList(String name, Statement statement, boolean all){
		String sql = null;
		if(all){
			sql = "Select idLocations, street "+
			"FROM locations;";
		}else{
			String searchable = "%" + name.replace(' ', '%') + "%";
			sql = "Select idLocations, street "+
							"FROM locations "+
							"WHERE street LIKE '"+searchable+"';";
		}
		try {
			rs = statement.executeQuery(sql);
		} catch (SQLException e) {
			System.out.println("sql:"+sql);
			e.printStackTrace();
		}
		
	}

	public boolean next() throws SQLException{
		return rs.next();
	}
	
	public int getID() throws SQLException{
		return rs.getInt("idLocations");
	}
	
	public String getStreetName() throws SQLException{
		return rs.getString("street");
	}
	
	public static void main(String[] args) {
		try {
			final CarPoolStore cps = new CarPoolStoreImpl();
			
			JFrame jframe = new JFrame();
			GridBagLayout jframeLayout = new GridBagLayout();
			jframe.getContentPane().setLayout(jframeLayout);
			jframe.setSize(907, 777);
			jframe.setVisible(true);
			jframe.setPreferredSize(new java.awt.Dimension(907, 777));
			jframeLayout.rowWeights = new double[] {0.0, 0.1, 0.1, 0.1};
			jframeLayout.rowHeights = new int[] {30, 7, 7, 7};
			jframeLayout.columnWeights = new double[] {0.0, 0.0, 0.1, 0.1};
			jframeLayout.columnWidths = new int[] {245, -66, 7, 7};
			{
				jTextField1 = new JTextField();
				jframe.getContentPane().add(jTextField1, new GridBagConstraints(0, 0, 2, 1, 0.0, 0.0, GridBagConstraints.CENTER, GridBagConstraints.BOTH, new Insets(0, 0, 0, 0), 0, 0));
				jTextField1.setBounds(49, 28, 192, 21);
				jTextField1.addKeyListener(new KeyListener(){

					@Override
					public void keyPressed(KeyEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void keyReleased(KeyEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void keyTyped(KeyEvent e) {
						StringBuffer sb = new StringBuffer();
						System.out.println(jTextField1.getText()+Character.toString(e.getKeyChar()).trim());
						if(!jTextField1.getText().trim().equals("")){
							LocationList ll = cps.getLocations();//cps.findLocation(jTextField1.getText()+Character.toString(e.getKeyChar()).trim());
							try {
								while(ll.next()){
									sb.append(ll.getID() + "\t" + ll.getStreetName() + "\n");
								}
							} catch (SQLException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
							jTextArea1.setText(sb.toString());
						}
					}
					
				});
			}
			{
				jScrollPane1 = new JScrollPane();
				jframe.getContentPane().add(jScrollPane1, new GridBagConstraints(0, 1, 4, 3, 0.0, 0.0, GridBagConstraints.CENTER, GridBagConstraints.BOTH, new Insets(0, 0, 0, 0), 0, 0));
				jScrollPane1.setBounds(49, 66, 192, 183);
				{
					jTextArea1 = new JTextArea();
					jScrollPane1.setViewportView(jTextArea1);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
}
