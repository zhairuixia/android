package com.call;

public class Test {

	  public void say(){

	        System.out.println("hello");
	    }

	    public static void see(){

	        System.out.println("see");
	    }

	    public static void main(String[] args) {
	        Test test = new Test();

	        test.say();    // 第一种情况

	        test.see();

	        Test.see();    // 第二种情况

	    }

}
