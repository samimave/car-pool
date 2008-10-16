package car.pool.user.registration.servlet;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import car.pool.user.registration.RandomTextGenerator;

/**
 * Produces a image with some randomly chosen text and circles to make it harder to use a character recognition programme on it
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class BlurredImage extends HttpServlet {
	private static final long serialVersionUID = -3122614952838918947L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession s = request.getSession(false);
		if (s == null) {
			System.out.println("session is null");
		}
		response.setContentType("image/png");
		ServletOutputStream out = response.getOutputStream();
		createImage(out, s);
		out.close();
	}
	
	
	private void createImage(ServletOutputStream out, HttpSession session) throws IOException {
		BufferedImage image = new BufferedImage( 200, 100, BufferedImage.TYPE_INT_RGB );
		Graphics2D g2d = image.createGraphics();
		g2d.setColor(Color.white);
		g2d.fillRoundRect(0, 0, 200, 100, 10, 10);
		g2d.setStroke(new BasicStroke(3, BasicStroke.CAP_ROUND, BasicStroke.JOIN_MITER));
		g2d.setColor(Color.blue);
		int[] arr = {5,25,45,65,85,105};
		for(int i: arr) {
			g2d.drawOval(i, 5, 100, 100);
		}
		g2d.setColor(Color.black);
		Font font = new Font("Sans", Font.ITALIC, 20);
		g2d.setFont(font);
		// now get the test to display
		RandomTextGenerator generator = new RandomTextGenerator();
		String verifierText = generator.get(Integer.parseInt(session.getAttribute("quote_pos").toString()));
		
		g2d.scale(1.5, 1.5);
		// draw it
		g2d.drawString(verifierText, 20, 50);
		//output the image to the PrintWriter
		try {
			ImageIO.write(image, "png", out);		
		} catch(IllegalArgumentException iaEx) {
			
		}
	}
}
