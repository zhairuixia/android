package com.cal;

import java.io.IOException;

import android.os.RemoteException;
import com.android.uiautomator.core.UiDevice;
import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class CalTest extends UiAutomatorTestCase{
	
	public void testDemo() throws UiObjectNotFoundException,RemoteException{
		UiDevice device = getUiDevice();
		
		// 唤醒屏幕
		device.wakeUp();
		assertTrue("screenOn: can't wakeup", device.isScreenOn());
		
		// 回到HOME
		device.pressHome();
		sleep(1000);
		
		// 启动计算器App
		try {
		Runtime.getRuntime().exec("am start -n com.android.calculator2/.Calculator");
		//Runtime.getRuntime().exec("am start -n home.solo.plugin.calculator/.Calculator");
		} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		
		 
		
		sleep(1000);
		
		UiObject zeroButton = new UiObject(new UiSelector().text("0"));
		assertTrue("zeroButton not found", zeroButton.exists());
		UiObject oneButton = new UiObject(new UiSelector().text("1"));
		assertTrue("oneButton not found", oneButton.exists());
		UiObject twoButton = new UiObject(new UiSelector().text("2"));
		assertTrue("twoButton not found", twoButton.exists());
		UiObject threeButton = new UiObject(new UiSelector().text("3"));
		assertTrue("threeButton not found", threeButton.exists());
		UiObject fourButton = new UiObject(new UiSelector().text("4"));
		assertTrue("fourButton not found", fourButton.exists());
		UiObject fiveButton = new UiObject(new UiSelector().text("5"));
		assertTrue("fiveButton not found", fiveButton.exists());
		UiObject sixButton = new UiObject(new UiSelector().text("6"));
		assertTrue("sixButton not found", sixButton.exists());
		UiObject sevenButton = new UiObject(new UiSelector().text("7"));
		assertTrue("sevenButton not found", sevenButton.exists());
		UiObject eightButton = new UiObject(new UiSelector().text("8"));
		assertTrue("eightButton not found", eightButton.exists());
		UiObject nineButton = new UiObject(new UiSelector().text("9"));
		assertTrue("nineButton not found", nineButton.exists());
		//UiObject delButton = new UiObject(new UiSelector().text("C"));
		//assertTrue("delButton not found", delButton.exists());
		UiObject lebracketButton = new UiObject(new UiSelector().text("("));
		assertTrue("lebracketButton not found", lebracketButton.exists());
		UiObject ribracketButton = new UiObject(new UiSelector().text(")"));
		assertTrue("ribracketButton not found", ribracketButton.exists());
		UiObject piButton = new UiObject(new UiSelector().text("π"));
		assertTrue("piButton not found", piButton.exists());
		UiObject multiButton = new UiObject(new UiSelector().text("×"));
		assertTrue("multiButton not found", multiButton.exists());
		UiObject devideButton = new UiObject(new UiSelector().text("÷"));
		assertTrue("devideButton not found", devideButton.exists());
		UiObject plusButton = new UiObject(new UiSelector().text("+"));
		assertTrue("plusButton not found", plusButton.exists());
		UiObject minusButton = new UiObject(new UiSelector().text("−"));
		assertTrue("minusButton not found", minusButton.exists());
		UiObject pointButton = new UiObject(new UiSelector().text("."));
		assertTrue("pointButton not found", pointButton.exists());
		UiObject genButton = new UiObject(new UiSelector().text("√"));
		assertTrue("genButton not found", genButton.exists());
		UiObject jiechengButton = new UiObject(new UiSelector().text("!"));
		assertTrue("jiechengButton not found", jiechengButton.exists());
		//UiObject percentButton = new UiObject(new UiSelector().text("%"));
		//assertTrue("percentButton not found", percentButton.exists());
		//UiObject cifangButton = new UiObject(new UiSelector().text("^"));
		//assertTrue("cifangButton not found", cifangButton.exists());
		sleep(100);

		UiObject equalButton = new UiObject(new UiSelector().text("="));
		assertTrue("equalButton not found", equalButton.exists());

		
		twoButton.click();
		//sleep(100);
		multiButton.click();
		//sleep(100);
		eightButton.click();
		//sleep(100);
		equalButton.click();
		sleep(100);
		minusButton.click();
		//sleep(100);
		genButton.click();
		//sleep(100);
		nineButton.click();
		//sleep(100);
		plusButton.click();
		//sleep(100);
		zeroButton.click();
		//sleep(100);
		pointButton.click();
		//sleep(100);
		oneButton.click();
		//sleep(100);
		equalButton.click();
		sleep(100);
		
		
		UiObject switcher = new UiObject(
				new UiSelector()
				//.resourceId("home.solo.plugin.calculator:id/display"));
				.resourceId("com.android.calculator2:id/display"));
				
				UiObject result = switcher.getChild(new UiSelector().index(0));
				System.out.print("text is :" + result.getText());
				assertTrue("result != 13.1", result.getText().equals("13.1"));
	}

		 
		
}
