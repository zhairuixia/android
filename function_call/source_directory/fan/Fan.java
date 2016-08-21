public class Fan {
	final static int slow = 1;
	final static int medium = 2;
	final static int fast = 3;
	private int speed = slow;
	private boolean on = false;
	private double radius = 5;
	private String color = "blue";

	public int getSpeed() {
		return speed;
	}

	public void setSpeed(int sp) {
		speed = sp;
	}

	public boolean getOn() {
		return on;
	}

	public void setOn(boolean on1) {
		on = on1;
	}

	public double getRadius() {
		return radius;
	}

	public void setRadius(double r) {
		radius = r;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String a) {
		color = a;
	}

	Fan() {
	}

	public String toString() {
		if (this.getOn() == true) {
			return "风扇转速：" + this.getSpeed() + "      风扇颜色：" + this.getColor()
					+ "  半径：" + this.getRadius();
		} else
			return "fan is off" + "   风扇颜色：" + this.getColor() + "     半径："
					+ this.getRadius();
	}
}