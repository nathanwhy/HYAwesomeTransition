//
//  CustomCollectionViewFlowLayout.m
//  HYAwesomeTransitionDemo
//
//  Created by nathan on 15/7/30.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

@implementation CustomCollectionViewFlowLayout

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultSetting];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupDefaultSetting];
    }
    return self;
}

- (void)setupDefaultSetting{
    self.itemSize = CGSizeMake(120, 120);
    self.minimumInteritemSpacing = 5;
}

@end
