//
//  WWHCyclicScrollImageView.h
//  CyclicScroll
//
//  Created by kele on 2017/6/12.
//  Copyright © 2017年 daGuanJiaJinRong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageClickWithIndexBlock)(NSInteger index,NSArray *images);

@interface WWHCyclicScrollImageView : UIView
/**
 *图片数组
 */
@property (nonatomic, strong) NSArray *imageArrays;
/**
 *图片点击的事件
 */
@property (nonatomic, copy) ImageClickWithIndexBlock imageClickWithIndexBlock;
/**
 *设置滚动时间间隔
 */
@property (nonatomic, assign) NSInteger durationTime;

/**
 *初始化
 */
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray;


@end
