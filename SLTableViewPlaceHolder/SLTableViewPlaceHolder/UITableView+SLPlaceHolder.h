//
//  UITableView+SLTableViewPlaceHolder.h
//  SLTableViewPlaceHolder
//
//  Created by 孙磊 on 2017/5/15.
//  Copyright © 2017年 孙磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLDefaultView;
@interface UITableView (SLPlaceHolder)

@property (nonatomic, assign) BOOL            sl_isShowPlaceHolder; //是否显示占位图，默认为YES显示
@property (nonatomic, strong) UIView        * sl_customPlaceHolderView;
@property (nonatomic, strong) SLDefaultView * sl_defaultPlaceHolder ;
@end


@interface UICollectionView (SLPlaceHolder)

@property (nonatomic, assign) BOOL            sl_isShowPlaceHolder; //是否显示占位图，默认为YES显示
@property (nonatomic, strong) UIView        * sl_customPlaceHolderView;
@property (nonatomic, strong) SLDefaultView * sl_defaultPlaceHolder ;
@end


@interface SLDefaultView : UIView


@end
