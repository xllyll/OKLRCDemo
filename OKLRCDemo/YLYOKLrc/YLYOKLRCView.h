//
//  YLYOKLRCView.h
//  OKLRCDemo
//
//  Created by 楊盧银Mac on 14-5-15.
//  Copyright (c) 2014年 com.yly16. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define KVelocity = 0.01;
typedef enum : NSUInteger {
    textAlignmentLeft,
    textAlignmentRight,
    textAlignmentCenter,
} Lrc_textAlignment;

typedef enum : NSUInteger {
    showTypeSinge,
    showTypeDouble,
    showTypeList,
} Lrc_showType;

@interface YLYOKLRCView : UIView
{
    float KVelocity;
}
@property (strong , nonatomic)UILabel *lrcLabel;
@property (strong , nonatomic)UILabel *OKlrcLabel;
//字体颜色
@property (strong , nonatomic)UIColor *lrcColor;
@property (strong , nonatomic)UIColor *OKlrcColor;
//字体
@property (strong , nonatomic)UIFont *iFont;
//字体对齐方式
@property (assign , nonatomic)Lrc_textAlignment textAlignment;
//显示风格
@property (assign , nonatomic)Lrc_showType showType;

-(void)beginOKLrcFromPath:(NSString*)path;

-(void)up_velocity;
-(void)down_velocity;
@end
