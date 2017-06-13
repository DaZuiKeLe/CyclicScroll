//
//  ViewController.m
//  CyclicScroll
//
//  Created by kele on 2017/6/12.
//  Copyright © 2017年 daGuanJiaJinRong. All rights reserved.
//

#import "ViewController.h"
#import "WWHCyclicScrollImageView.h"

@interface ViewController ()
@property (nonatomic,weak)WWHCyclicScrollImageView *scrollImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:@"xiaohuangren-0",@"xiaohuangren-1",@"xiaohuangren-2", nil];
    WWHCyclicScrollImageView *scrollImageView = [[WWHCyclicScrollImageView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 200) imageArray:imageArray];
    scrollImageView.imageClickWithIndexBlock = ^(NSInteger index, NSArray *images) {
        NSLog(@"点击了第%ld个图片",index);
    };
    [self.view addSubview:scrollImageView];
    self.scrollImageView = scrollImageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
