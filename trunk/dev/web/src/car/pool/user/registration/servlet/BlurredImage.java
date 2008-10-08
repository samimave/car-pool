package car.pool.user.registration.servlet;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import car.pool.user.registration.RandomTextGenerator;

public class BlurredImage extends HttpServlet {
	private static final long serialVersionUID = -3122614952838918947L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		response.setContentType("image/png");
		ServletOutputStream out = response.getOutputStream();
		createImage(out, request.getSession());
		out.close();
	}
	
	
	private void createImage(ServletOutputStream out, HttpSession session) throws IOException {
		BufferedImage image = new BufferedImage( 200, 100, BufferedImage.TYPE_INT_RGB );
		Graphics2D g2d = image.createGraphics();
		g2d.setColor(Color.white);
		g2d.fillRoundRect(0, 0, 200, 100, 10, 10);
		g2d.setStroke(new BasicStroke(3, BasicStroke.CAP_ROUND, BasicStroke.JOIN_MITER));
		g2d.setColor(Color.blue);
		int[] arr = {5,25,35,45,55,65,75,85};
		for(int i: arr) {
			g2d.drawOval(i, 5, 100, 100);
		}
		g2d.setColor(Color.black);
		Font font = new Font("Sans", Font.ITALIC, 20);
		g2d.setFont(font);
		RandomTextGenerator generator = new RandomTextGenerator();
		Random r = new Random();
		Integer pos = r.nextInt(generator.size());
		String verifierText = generator.get(pos);
		g2d.scale(1.5, 1.5);
		g2d.drawString(verifierText, 20, 50);
		session.setAttribute("quote_pos", pos);
		
		try {
			ImageIO.write(image, "png", out);		
		} catch(IllegalArgumentException iaEx) {
			
		}
	}
}
