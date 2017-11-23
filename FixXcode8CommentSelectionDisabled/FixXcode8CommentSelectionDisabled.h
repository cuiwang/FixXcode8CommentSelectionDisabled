//
//  FixXcode8CommentSelectionDisabled.h
//  FixXcode8CommentSelectionDisabled
//
//  Created by 崔旺 on 2017/11/23.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface FixXcode8CommentSelectionDisabled : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end