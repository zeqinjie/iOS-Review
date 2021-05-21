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
    
    // insert code here...
    NSLog(@"Person_IMPL %zd", sizeof(struct Person_IMPL)); // 24（成员最大是8）
    Person *per = [Person new];
    NSLog(@"per %zd", sizeof(per)); // 8 注意：这里的数值是per这个【指针变量】的大小
    NSLog(@"per %zd", class_getInstanceSize(per.class)); // 24
    NSLog(@"per %zd", malloc_size((__bridge const void *)(per))); // 32
    
    // sizeof：是一个运算符，获取的是类型的大小（int、size_t、结构体、指针变量等），这些数值在程序编译时就转成常数，程序运行时是直接获取的
    // class_getInstanceSize：是一个函数（调用时需要开辟额外的内存空间），程序运行时才获取，计算的是类的大小（至少需要的大小）
    
    // class_getInstanceSize：创建的对象【至少】需要的内存大小
    // 不考虑malloc函数的话，内存对齐一般是以【8】对齐
    
    // malloc_size：堆空间【实际】分配给对象的内存大小
    // 在Mac、iOS中的malloc函数分配的内存大小总是【16】的倍数
}


/*
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
 
 */


@end
