//
//  DPSearchConstFile.h
//  historySearch
//
//  Created by Mister_Sun on 16/12/15.
//  Copyright © 2016年 SurSen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DPMargin 10 // 边距宽度

#define CELLID @"cellID" 

/*******   排名布局的时候每一个tag的高度   *******/
#define RankViewHeight 40

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define DPTextColor DPColor(113, 113, 113)  // 文本字体颜色

// 颜色
#define DPColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define DPSearchHistoriesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DPSearchhistories.plist"] // 搜索历史存储路径

/**  搜索占位文字  */
UIKIT_EXTERN NSString *const DPSearchPlacehoderText;

UIKIT_EXTERN NSString *const DPHotSearchText;

UIKIT_EXTERN NSString *const DPClearSearchText;

UIKIT_EXTERN NSString *const DPHistorySearchText;
