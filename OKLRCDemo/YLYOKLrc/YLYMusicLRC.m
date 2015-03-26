//
//  YLYMusicLRC.m
//  OKLRCDemo
//
//  Created by 楊盧银Mac on 14-5-16.
//  Copyright (c) 2014年 com.yly16. All rights reserved.
//

#import "YLYMusicLRC.h"

@implementation YLYMusicLRC
-(YLYMusicLRC *)initWithLRCFile:(NSString *)path{
    self = [super init];
    if (self) {
        NSError *error;
        self.lrcList= [[NSMutableArray alloc]init];
        NSString *LRCFileStr = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        self.lrcList = [self showLRC:LRCFileStr];
        
    }
    return self;
}
-(NSMutableArray*)showLRC:(NSString*)lrcStr{
    NSMutableArray *rootList = [[NSMutableArray alloc]init];
    NSArray *array = [lrcStr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < array.count; i++) {
        NSString *tempStr = [array objectAtIndex:i];
        NSArray *lineArray = [tempStr componentsSeparatedByString:@"]"];
        for (int j = 0; j < [lineArray count]-1; j ++) {
            
            if ([lineArray[j] length] > 8) {
                NSMutableDictionary *rootDic = [[NSMutableDictionary alloc]init];
                NSString *str1 = [tempStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [tempStr substringWithRange:NSMakeRange(6, 1)];
                if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                    NSString *lrcStr = [lineArray lastObject];
                    NSString *timeStr = [[lineArray objectAtIndex:j] substringWithRange:NSMakeRange(1, 8)];//分割区间求歌词时间
                    //把时间 和 歌词 加入词典
                    NSMutableArray *list = [[NSMutableArray alloc]init];
                    NSArray *tempArray = [lrcStr componentsSeparatedByString:@"<"];
                    NSMutableString *linelrcStr = [[NSMutableString alloc]init];
                    float sum = 0.0;
                    for (int k = 0;k < tempArray.count-1; k++) {
                        
                        NSArray *Diclist = [[tempArray objectAtIndex:k+1] componentsSeparatedByString:@">"];
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                        [dic setObject:[Diclist objectAtIndex:0] forKey:@"time"];
                        [dic setObject:[Diclist objectAtIndex:1] forKey:@"string"];
                        [linelrcStr appendString:[Diclist objectAtIndex:1]];
                        sum += [[tempArray objectAtIndex:k+1]floatValue];
                        [list addObject:dic];
                    }
                    if (linelrcStr.length!=0) {
                        [rootDic setObject:linelrcStr forKey:@"lrc"];
                    }else{
                        [rootDic setObject:lrcStr forKey:@"lrc"];
                    }
                    [rootDic setObject:[NSNumber numberWithFloat:sum/1000] forKey:@"alltime"];
                    [rootDic setObject:timeStr forKey:@"lrctime"];
                    [rootDic setObject:list forKey:@"timeList"];
                    
                    [rootList addObject:rootDic];
                }
            }
        }
    }
    return rootList;
}



@end
