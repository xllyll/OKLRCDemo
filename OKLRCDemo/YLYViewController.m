//
//  YLYViewController.m
//  OKLRCDemo
//
//  Created by 楊盧银Mac on 14-5-15.
//  Copyright (c) 2014年 com.yly16. All rights reserved.
//

#import "YLYViewController.h"
#import "YLYOKLRCView.h"
#import <AVFoundation/AVFoundation.h>

@interface YLYViewController ()
{
    int _count;
    int _lineCount;
    int _SingleCount;//单个歌词
}
@property (strong , nonatomic)AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet YLYOKLRCView *lrcView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (strong , nonatomic)NSMutableArray *list;
@end

@implementation YLYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *path1 =[[NSBundle mainBundle]pathForResource:@"月半小夜曲" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path1];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [self.player play];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"李克勤 - 月半小夜曲" ofType:@"txt"];
    _lrcView.textAlignment = textAlignmentRight;
    [_lrcView beginOKLrcFromPath:path];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateMusicTimeLabel) userInfo:self repeats:YES];
}

//TODO:更新ing歌曲播放时间
-(void)updateMusicTimeLabel{
    NSLog(@"%f",_player.currentTime);
    if ((int)self.player.currentTime % 60 < 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)self.player.currentTime / 60, (int)self.player.currentTime % 60];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)self.player.currentTime / 60, (int)self.player.currentTime % 60];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
