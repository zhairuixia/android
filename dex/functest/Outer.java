package com.func;

public class Outer {
	private static int i = 1;
    private int j = 10;
    private int k = 20;

    public static void outer_f1() {}

    public void outer_f2() {}
    class Inner {
        int j = 100; // 内部类和外部类的实例变量可以共存
        
        void inner_f1() {
               
            // 在内部类中访问内部类自己的变量直接用变量名
            System.out.println(j);
            
            // 在内部类中访问内部类自己的变量也可以用this.变量名
            System.out.println(this.j);
            
            // 在内部类中访问外部类中与内部类同名的实例变量用外部类名.this.变量名
            System.out.println(Outer.this.j);
            
            // 如果内部类中没有与外部类同名的变量，则可以直接用变量名访问外部类变量
            System.out.println(k);
            System.out.println(i);          

            outer_f1();
            outer_f2();
        }
    }
    // 外部类的非静态方法访问成员内部类
    public void outer_f3() {
        Inner inner = new Inner();
        inner.inner_f1();
    }
    // 外部类的静态方法访问成员内部类
    public static void outer_f4() {
        // step1 建立外部类对象
        Outer out = new Outer();
        // step2 根据外部类对象建立内部类对象
        Inner inner = out.new Inner();
        // step3 访问内部类的方法
        inner.inner_f1();
    }
    public static void main(String[] args) {
        Outer out = new Outer();
        Outer.Inner outin = out.new Inner();
        outin.inner_f1();
    }
}
