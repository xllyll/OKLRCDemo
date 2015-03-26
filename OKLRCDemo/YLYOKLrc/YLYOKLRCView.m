//
//  YLYOKLRCView.m
//  OKLRCDemo
//
//  Created by 楊盧银Mac on 14-5-15.
//  Copyright (c) 2014年 com.yly16. All rights reserved.
//

#import "YLYOKLRCView.h"
#import "YLYMusicLRC.h"
@interface YLYOKLRCView()
{
    
    NSTimer   *_musicTimer;//音乐时间计数
    NSInteger lineNumber;  //单句文字计数
    NSInteger singeNumber; //单个文字计数
}
@property (strong , nonatomic)YLYMusicLRC *ok_lrc;
@property (copy   , nonatomic)NSString    *lrc_String;

@property (assign , nonatomic)double musicTime;
@property (assign , nonatomic)double musicbeginTime;
@end

@implementation YLYOKLRCView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self comfig];
    }
    return self;
}
-(void)awakeFromNib{
    [self comfig];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setLrcColor:(UIColor *)lrcColor{
    _lrcColor = lrcColor;
    _OKlrcLabel.textColor = _lrcColor;
}
-(void)comfig{
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    _lrcColor = [UIColor blackColor];
    _OKlrcColor = [UIColor redColor];
    _iFont = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    self.clipsToBounds = YES;
    lineNumber = 0;
    _lrcLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _lrcLabel.backgroundColor = [UIColor clearColor];
    _lrcLabel.textColor = _lrcColor;
    _lrcLabel.font = _iFont;
    _lrcLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_lrcLabel];
    
    _OKlrcLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _OKlrcLabel.backgroundColor = [UIColor clearColor];
    _OKlrcLabel.textColor = [UIColor redColor];
    _OKlrcLabel.textColor = _OKlrcColor;
    _OKlrcLabel.font = _iFont;
    _OKlrcLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_OKlrcLabel];
}
-(void)setOKLRCLabelString:(NSString *)string{
    //设置字体,包括字体及其大小
    UIFont *font = self.lrcLabel.font;
    CGSize titleSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    float x = (self.frame.size.width-titleSize.width)/2;
    if (_textAlignment==textAlignmentCenter) {
        _lrcLabel.frame = CGRectMake(x, 0, titleSize.width, self.frame.size.height);
        _OKlrcLabel.frame = CGRectMake(x, 0, 0, _lrcLabel.frame.size.height);
    }
    if (_textAlignment==textAlignmentLeft) {
        _lrcLabel.frame = CGRectMake(0, 0, titleSize.width, self.frame.size.height);
        _OKlrcLabel.frame = CGRectMake(0, 0, 0, _lrcLabel.frame.size.height);
    }
    if (_textAlignment==textAlignmentRight) {
        _lrcLabel.frame = CGRectMake(self.bounds.size.width-titleSize.width, 0, titleSize.width, self.frame.size.height);
        _OKlrcLabel.frame = CGRectMake(self.bounds.size.width-titleSize.width, 0, 0, _lrcLabel.frame.size.height);
    }
    _lrc_String = string;
    _lrcLabel.text = self.lrc_String;
    _OKlrcLabel.text = self.lrc_String;

}
-(void)beginOKLrcFromPath:(NSString *)path{
    _musicTime = 0;
    KVelocity=0.01f;
    _ok_lrc = [[YLYMusicLRC alloc]initWithLRCFile:path];
    NSDictionary *info = _ok_lrc.lrcList[lineNumber];
    if(_showType == showTypeSinge){
        [self setOKLRCLabelString:info[@"lrc"]];
    }
    if(_showType == showTypeDouble){
        
    }
    if(_showType == showTypeList){
        
    }
    
    NSString *begin = [[info[@"lrctime"] componentsSeparatedByString:@":"] lastObject];
    _musicbeginTime = [begin doubleValue];
    _musicTimer = [NSTimer scheduledTimerWithTimeInterval:KVelocity target:self selector:@selector(upDateOKLRCView:) userInfo:self repeats:YES];
    
}
-(void)upDateOKLRCView:(NSTimer*)sender{
    _musicTime+=0.01;
    if (lineNumber>=_ok_lrc.lrcList.count) {
        [self stopOKLRC];
        return;
    }
    NSDictionary *info = _ok_lrc.lrcList[lineNumber];
    
    NSArray *timeStrArray = [_ok_lrc.lrcList[lineNumber+1][@"lrctime"] componentsSeparatedByString:@":"];
    float line_beginTime = [[timeStrArray firstObject] doubleValue]*60+[[timeStrArray lastObject] doubleValue];
    if (_musicTime>=line_beginTime) {
        NSLog(@">>>>>>>>>>>>>>>");
        info = _ok_lrc.lrcList[lineNumber+1];
        [self setOKLRCLabelString:info[@"lrc"]];
        lineNumber++;
        singeNumber=0;
    }
    NSArray *timeArray = info[@"timeList"];
    if (timeArray<=0 || timeArray==nil) {
        return;
    }
    if (_musicTime >= _musicbeginTime) {
        
        NSDictionary *dic = timeArray[singeNumber];
        double miao = [dic[@"time"] floatValue]/1000;
        double width = _lrcLabel.bounds.size.width/timeArray.count;
        double width1 =width/miao;
        [self updateLineLrc:width1 singeWidth:width languageNumber:timeArray.count];
    }
}
-(void)updateLineLrc:(double)with singeWidth:(double)singeWidth languageNumber:(NSInteger)languageNum{
    
    double myWidth = _OKlrcLabel.bounds.size.width;
    myWidth+=(with/100);
    
    if (myWidth>(singeNumber+1)*singeWidth) {
        singeNumber ++;
    }
    if (singeNumber >= languageNum) {
        singeNumber=0;
//        lineNumber++;
//        [self updateLrc];
//        NSLog(@">>>>>>>%d",lineNumber);
//        return;
    }
    _OKlrcLabel.frame = CGRectMake(_OKlrcLabel.frame.origin.x, _OKlrcLabel.frame.origin.y, myWidth, _OKlrcLabel.frame.size.height);
}
-(void)updateLrc{
    NSDictionary *info = _ok_lrc.lrcList[lineNumber];
    [self setOKLRCLabelString:info[@"lrc"]];
}
-(void)up_velocity{
    KVelocity-=0.002;
    _musicTimer = [NSTimer scheduledTimerWithTimeInterval:KVelocity target:self selector:@selector(upDateOKLRCView:) userInfo:self repeats:YES];
}

-(void)down_velocity{
    KVelocity+=0.002;
    _musicTimer = [NSTimer scheduledTimerWithTimeInterval:KVelocity target:self selector:@selector(upDateOKLRCView:) userInfo:self repeats:YES];
}
-(void)stopOKLRC{
    [_musicTimer invalidate];
    _musicTimer = nil;
}
@end
