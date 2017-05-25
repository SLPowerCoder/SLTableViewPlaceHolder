# SLTableViewPlaceHolder
runtime实现tableView数据状态显示展位图

## How to use
只需要把分类拖进项目里即可，如果你想认为控制展位图是否显示，你还需要import "UITableView+SLTableViewPlaceHolder.h"头文件

## Swizzling 

``` Objective C
void swizzleMethod(Class cls,SEL originalSelector,SEL swizzledSelector) {

//1.根据selector获取指向方法实现的指针
Method originalMethod = class_getInstanceMethod(cls, originalSelector);
Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);

//2.给原方法添加实现
BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

//3.如果添加成功说明原方法还没有被实现，这也是我们为什么先添加，而不是直接exchange
if (didAddMethod) {
class_replaceMethod(cls,
swizzledSelector,
method_getImplementation(originalMethod),
method_getTypeEncoding(originalMethod));
} else { //如果原来的selector有实现的话，则会添加失败，这时已经证明了原方法有对应的实现，所以可以直接exchange了
method_exchangeImplementations(originalMethod, swizzledMethod);
}
}

```

## Summary

1. 使用runtime swizzling要注意，在使用的过程中一定要调用交换前的方法，不要调用交换后的方法。想初始化父类的该方法，一定要用self调用交换后的方法，因为交换后的方法其实指向原来的方法，这样写是不会死循环的，如果调用以前的方法那才会产生死循环呢！
2. 要把runtime代码写在load方法中，load方法会在Xcode编译项目的时候会执行一次，即便对应VC没有被使用，该VC中的load方法也会被调用，initialize方法会在类（或者继承他的子类）第一次接收消息之前会被调用一次，但是如果这个类没用调用方法的话，那么initialize是不会被调用的，这也是和load的区别
3. 要注意安全性，防止为了防止load方法被认为的调用一次，我们一般会在load中用dispatch once来包裹runtime代码，以保证线程安全


