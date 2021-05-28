//
//  OCClassViewController.m
//  iOS-Review
//
//  Created by zhengzeqin on 2021/5/21.
//

#import "OCClassViewController.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
struct NSObject_IMPL {
    Class isa;
};

struct Person_IMPL {
    struct NSObject_IMPL NSObject_IVARS; // 8
    int _age; // 4
    int _height; // 4
    int _money; // 4
};

@interface Person : NSObject
{
    int _age; // 4
    int _height; // 4
    int _money; // 4
}
@end

@implementation Person
@end

@implementation OCClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self printMemorySize];

    
}

#pragma mark - 对象内存大小
- (void)printMemorySize {
    // sizeof：是一个运算符，获取的是类型的大小（int、size_t、结构体、指针变量等），这些数值在程序编译时就转成常数，程序运行时是直接获取的
    // class_getInstanceSize：是一个函数（调用时需要开辟额外的内存空间），程序运行时才获取，计算的是类的大小（至少需要的大小）
    
    // class_getInstanceSize：创建的对象【至少】需要的内存大小
    // 不考虑malloc函数的话，内存对齐一般是以【8】对齐
    
    // malloc_size：堆空间【实际】分配给对象的内存大小
    // 在Mac、iOS中的malloc函数分配的内存大小总是【16】的倍数
    
    NSLog(@"Person_IMPL %zd", sizeof(struct Person_IMPL)); // 24（成员最大是8）
    Person *per = [Person new];
    NSLog(@"per %zd", sizeof(per)); // 8 注意：这里的数值是per这个【指针变量】的大小
    NSLog(@"per %zd", class_getInstanceSize(per.class)); // 24
    NSLog(@"per %zd", malloc_size((__bridge const void *)(per))); // 32
    
    /*
     * 总结
     * 系统以【16】为倍数分配的内存大小是由【calloc】函数实现的，这个函数在libmalloc的源码里面
     * libmalloc：【calloc】->【malloc_zone_calloc】
     * MJ结论：以16为倍数是操作系统最优的内存分配方案，有利于内存管理（方便计算，免得乱七八糟）
     * 参考【gnu】
     
     大部分操作系统都会内存对齐
     
     可以查看【gnu】（Linux系统很多都是使用gnu里面的用法）的glibc的malloc源码，查看人家的内存分配方法：
     
     搜索 #define MALLOC_ALIGNMENT
     可以看到一个是16，
     
     另一个是
     #define MALLOC_ALIGNMENT (2 * SIZE_SZ < __alignof__ (long double) \
     ? __alignof__ (long double) : 2 * SIZE_SZ)
     
     SIZE_SZ是
     #define SIZE_SZ (sizeof (INTERNAL_SIZE_T))
     
     INTERNAL_SIZE_T是
     # define INTERNAL_SIZE_T size_t

     在iOS里面，这个size_t是8，__alignof__ (long double)是16
     所以 #define MALLOC_ALIGNMENT 在iOS里面相当于 (2 * 8 < 16 ? 16 : 2 * 8) >>>> 16
     
     a. 将 Objective-C 代码转换为C\C++代码:
     xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc OC源文件 -o 输出的CPP文件
     如果需要链接其他框架，使用 -framework 参数。比如-framework UIKit
     
     b. 常用的LLDB指令
     print、p：打印
     po：打印对象

     读取内存
     memory read/数量格式字节数  内存地址
     x/数量格式字节数  内存地址
     x/3xw  0x10010

     修改内存中的值
     memory  write  内存地址  数值
     memory  write  0x0000010  10

     bt 打印调用堆栈信息

     call 调用方法
     */

}


- (void)printClass {
    
    /*
     * OC对象分3种：
        1.instance对象（实例对象）
        2.class对象（类对象）
        3.meta-class对象（元类对象）
     */
    
    
    /* 类对象 */
    // 每个类在内存中有且只有一个class对象
    
    // class对象存储的信息包括：
    // isa指针
    // superclass指针
    // 类的属性信息（@property）
    // 类的对象方法信息（instance method，带减号那种）
    // 类的协议信息（protocol）
    // 类的成员变量信息（ivar，类型、名称等）
    // ......（其他）
    
    /* 元类对象 */
    // 获取类对象
    Class cls = [NSObject class];
    NSLog(@"cls %p", cls);
    
    // 获取元类对象
    // 将类对象当作参数传入可获取元类对象
    Class cls1 = object_getClass(cls);
    NSLog(@"cls1 %p", cls1);
    NSLog(@"cls1 %@", NSStringFromClass(cls1));
    
    // 对类对象使用class函数可以获取元类对象吗？
    // 答：不可以，无论用多少次返回的都是同一个类对象（自己）
    Class cls2 = [cls class];
    NSLog(@"cls2 %p", cls2);
    
    // 每个类在内存中有且只有一个meta-class对象
    
    // meta-class对象和class对象的【内存结构】是一样的，但用途不一样。
    
    // meta-class对象存储的信息包括：
    // isa指针
    // superclass指针
    // 类的类方法信息（class method，带加号那种）
    // ......（其他为空）
    
    // 判断是否为元类对象
    NSLog(@"cls1 %d, cls2 %d", class_isMetaClass(cls1), class_isMetaClass(cls2));
    
    //【object_getClass】函数：
    // 如果传的是instance对象，返回class对象
    // 如果传的是class对象，返回meta-class对象
    // 如果传的是meta-class对象，返回NSObject（基类）的meta-class对象
    
    //【objc_getClass】函数：
    // 传入类名字符串，返回对应的class对象，不会是meta-class对象
    
    //【class】函数：返回对应的class对象，不会是meta-class对象
    
   
    
}







@end
