//
//  UITableView+SLTableViewPlaceHolder.m
//  SLTableViewPlaceHolder
//
//  Created by 孙磊 on 2017/5/15.
//  Copyright © 2017年 孙磊. All rights reserved.
//

#import "UITableView+SLPlaceHolder.h"
#import <objc/runtime.h>

#define TableView_W self.view.frame.size.width
#define TableView_H self.view.frame.size.height

#define PlaceHolder_W 100
#define PlaceHolder_H 100

const NSString * sl_isShowPlaceHolder_key      =  @"sl_isShowPlaceHolder";
const NSString * sl_customPlaceHolderView_key  =  @"sl_customPlaceHolderView";
const NSString * sl_defaultPlaceHolder_key     =  @"sl_defaultPlaceHolder";


#pragma mark - swizzling function

void swizzleMethod(Class cls,SEL originalSelector,SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark ----tableView-----

@implementation UITableView (SLPlaceHolder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        swizzleMethod(class,@selector(initWithFrame:style:), @selector(sl_initWithFrame:style:));
        swizzleMethod(class,@selector(setContentSize:),  @selector(sl_setContentSize:));
        swizzleMethod(class,@selector(layoutSubviews),  @selector(sl_layoutSubviews));
    });
}

#pragma mark -  Setter and  Getter
// 是否显示占位图
-(void)setSl_isShowPlaceHolder:(BOOL)sl_isShowPlaceHolder {
    objc_setAssociatedObject(self, (__bridge const void *)(sl_isShowPlaceHolder_key), @(sl_isShowPlaceHolder), OBJC_ASSOCIATION_ASSIGN);
    NSLog(@"~~sl_isShowPlaceHolder~--~%d",sl_isShowPlaceHolder);
    if (sl_isShowPlaceHolder) { //如果显示
        if (self.sl_customPlaceHolderView) { // 说明有自定义占位图
            [self bringSubviewToFront:self.sl_customPlaceHolderView];
        }else{
            self.sl_defaultPlaceHolder.hidden = NO;
            [self bringSubviewToFront:self.sl_defaultPlaceHolder];
        }
    }else{
        if (self.sl_customPlaceHolderView) { // 说明有自定义占位图
            self.sl_customPlaceHolderView.hidden = !sl_isShowPlaceHolder;
        }else{
            self.sl_defaultPlaceHolder.hidden = !sl_isShowPlaceHolder;
        }
    }
}

- (BOOL)sl_isShowPlaceHolder {
    return objc_getAssociatedObject(self, (__bridge const void *)(sl_isShowPlaceHolder_key));
}

// 自定义占位图
- (void)setSl_customPlaceHolderView:(UIView *)sl_customPlaceHolderView {

    self.sl_defaultPlaceHolder.hidden = !self.sl_isShowPlaceHolder;
    if (self.sl_customPlaceHolderView) { //将以前的移除
        [self.sl_customPlaceHolderView removeFromSuperview];
    }
    [self addSubview:sl_customPlaceHolderView];
    
    objc_setAssociatedObject(self, (__bridge const void *)(sl_customPlaceHolderView_key), sl_customPlaceHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sl_customPlaceHolderView {
    return objc_getAssociatedObject(self, (__bridge const void *)(sl_customPlaceHolderView_key));
}


// 默认占位图
- (void)setSl_defaultPlaceHolder:(SLDefaultView *)sl_defaultPlaceHolder {
    objc_setAssociatedObject(self, (__bridge const void *)(sl_defaultPlaceHolder_key), sl_defaultPlaceHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SLDefaultView *)sl_defaultPlaceHolder {
    
    SLDefaultView *defaultView = objc_getAssociatedObject(self, (__bridge const void *)(sl_defaultPlaceHolder_key));
    if (!defaultView) {
        defaultView = [[SLDefaultView alloc] initWithFrame:CGRectMake((self.frame.size.width - PlaceHolder_W)/2, (self.frame.size.height - PlaceHolder_H)/2, PlaceHolder_W, PlaceHolder_H)];
        defaultView.hidden = !self.sl_isShowPlaceHolder;
        [self addSubview:defaultView];
        
        objc_setAssociatedObject(self, (__bridge const void *)(sl_defaultPlaceHolder_key), defaultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return defaultView;
}


#pragma mark - Method Swizzling

- (instancetype)sl_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    UITableView *tableView = [self sl_initWithFrame:frame style:style];
    // 默认显示占位图，无论是默认占位图还是自定义占位图
    self.sl_isShowPlaceHolder = YES;
    return tableView;
}

// 会随着数据的填充而变化
- (void)sl_setContentSize:(CGSize)contentSize {
    [self sl_setContentSize:contentSize];

    BOOL isHavingData = NO; // 表示tableView中是否有数据
    NSInteger numberOfSections = [self numberOfSections];
    for (NSInteger i = 0; i < numberOfSections; i++) {
        if ([self numberOfRowsInSection:i] > 0) {
            isHavingData = YES;
        }
    }
    // 如果有数据就隐藏占位图
    self.sl_isShowPlaceHolder = !isHavingData;
}


-(void)sl_layoutSubviews{
    [self sl_layoutSubviews];
    
    if (self.sl_isShowPlaceHolder) {
        if (self.sl_customPlaceHolderView) {
            [self bringSubviewToFront:self.sl_customPlaceHolderView];
        }else{
            [self bringSubviewToFront:self.sl_defaultPlaceHolder];
        }
    }else{
        if (self.sl_customPlaceHolderView ) {
            self.sl_customPlaceHolderView.hidden = YES;
        }else{
            self.sl_defaultPlaceHolder.hidden = YES;
        }
    }
}
@end

#pragma mark ----collectionView-----

@implementation UICollectionView (SLPlaceHolder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        swizzleMethod(class,@selector(initWithFrame:collectionViewLayout:), @selector(sl_initWithFrame:collectionViewLayout:));
        swizzleMethod(class,@selector(setContentSize:),  @selector(sl_setContentSize:));
        swizzleMethod(class,@selector(layoutSubviews),  @selector(sl_layoutSubviews));
    });
}

#pragma mark -  Setter and  Getter
// 是否显示占位图
-(void)setSl_isShowPlaceHolder:(BOOL)sl_isShowPlaceHolder {
    objc_setAssociatedObject(self, (__bridge const void *)(sl_isShowPlaceHolder_key), @(sl_isShowPlaceHolder), OBJC_ASSOCIATION_ASSIGN);
    NSLog(@"~~sl_isShowPlaceHolder~--~%d",sl_isShowPlaceHolder);
    if (sl_isShowPlaceHolder) { //如果显示
        if (self.sl_customPlaceHolderView) { // 说明有自定义占位图
            [self bringSubviewToFront:self.sl_customPlaceHolderView];
        }else{
            self.sl_defaultPlaceHolder.hidden = NO;
            [self bringSubviewToFront:self.sl_defaultPlaceHolder];
        }
    }else{
        if (self.sl_customPlaceHolderView) { // 说明有自定义占位图
            self.sl_customPlaceHolderView.hidden = !sl_isShowPlaceHolder;
        }else{
            self.sl_defaultPlaceHolder.hidden = !sl_isShowPlaceHolder;
        }
    }
}

- (BOOL)sl_isShowPlaceHolder {
    return objc_getAssociatedObject(self, (__bridge const void *)(sl_isShowPlaceHolder_key));
}

// 自定义占位图
- (void)setSl_customPlaceHolderView:(UIView *)sl_customPlaceHolderView {
    
    self.sl_defaultPlaceHolder.hidden = !self.sl_isShowPlaceHolder;
    if (self.sl_customPlaceHolderView) { //将以前的移除
        [self.sl_customPlaceHolderView removeFromSuperview];
    }
    [self addSubview:sl_customPlaceHolderView];
    
    objc_setAssociatedObject(self, (__bridge const void *)(sl_customPlaceHolderView_key), sl_customPlaceHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sl_customPlaceHolderView {
    return objc_getAssociatedObject(self, (__bridge const void *)(sl_customPlaceHolderView_key));
}


// 默认占位图
- (void)setSl_defaultPlaceHolder:(SLDefaultView *)sl_defaultPlaceHolder {
    objc_setAssociatedObject(self, (__bridge const void *)(sl_defaultPlaceHolder_key), sl_defaultPlaceHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SLDefaultView *)sl_defaultPlaceHolder {
    
    SLDefaultView *defaultView = objc_getAssociatedObject(self, (__bridge const void *)(sl_defaultPlaceHolder_key));
    if (!defaultView) {
        defaultView = [[SLDefaultView alloc] initWithFrame:CGRectMake((self.frame.size.width - PlaceHolder_W)/2, (self.frame.size.height - PlaceHolder_H)/2, PlaceHolder_W, PlaceHolder_H)];
        defaultView.hidden = !self.sl_isShowPlaceHolder;
        [self addSubview:defaultView];
        
        objc_setAssociatedObject(self, (__bridge const void *)(sl_defaultPlaceHolder_key), defaultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return defaultView;
}


#pragma mark - Method Swizzling

- (instancetype)sl_initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    UICollectionView *collectionView = [self sl_initWithFrame:frame collectionViewLayout:layout];
    // 默认显示占位图，无论是默认占位图还是自定义占位图
    self.sl_isShowPlaceHolder = YES;
    return collectionView;
}

// 会随着数据的填充而变化
- (void)sl_setContentSize:(CGSize)contentSize {
    [self sl_setContentSize:contentSize];
    
    BOOL isHavingData = NO; // 表示tableView中是否有数据
    NSInteger numberOfSections = [self numberOfSections];
    for (NSInteger i = 0; i < numberOfSections; i++) {
        if ([self numberOfItemsInSection:i] > 0) {
            isHavingData = YES;
        }
    }
    // 如果有数据就隐藏占位图
    self.sl_isShowPlaceHolder = !isHavingData;
}


-(void)sl_layoutSubviews{
    [self sl_layoutSubviews];
    
    if (self.sl_isShowPlaceHolder) {
        if (self.sl_customPlaceHolderView) {
            [self bringSubviewToFront:self.sl_customPlaceHolderView];
        }else{
            [self bringSubviewToFront:self.sl_defaultPlaceHolder];
        }
    }else{
        if (self.sl_customPlaceHolderView ) {
            self.sl_customPlaceHolderView.hidden = YES;
        }else{
            self.sl_defaultPlaceHolder.hidden = YES;
        }
    }
}

@end


@implementation SLDefaultView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self createContents];
    }
    return self;
}

- (void)createContents{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bunny"]];
    imageView.frame = self.bounds;
    imageView.backgroundColor = [UIColor brownColor];
    [self addSubview:imageView];
}


@end

