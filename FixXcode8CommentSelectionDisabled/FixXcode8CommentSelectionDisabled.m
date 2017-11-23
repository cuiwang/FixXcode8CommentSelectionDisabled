//
//  FixXcode8CommentSelectionDisabled.m
//  FixXcode8CommentSelectionDisabled
//
//  Created by 崔旺 on 2017/11/23.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import "FixXcode8CommentSelectionDisabled.h"
#import "NSString+JKAdditions.h"

static FixXcode8CommentSelectionDisabled *sharedPlugin;

@interface FixXcode8CommentSelectionDisabled ()
@property(nonatomic, strong) NSTextView *activeTextView;
@end

@implementation FixXcode8CommentSelectionDisabled

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin {
  NSArray *allowedLoaders =
      [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
  if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
    sharedPlugin = [[self alloc] initWithBundle:plugin];
  }
}

+ (instancetype)sharedPlugin {
  return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle {
  if (self = [super init]) {
    // reference to plugin's bundle, for resource access
    _bundle = bundle;
    // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
    if (NSApp && !NSApp.mainMenu) {
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(applicationDidFinishLaunching:)
                                                   name:NSApplicationDidFinishLaunchingNotification
                                                 object:nil];
    } else {
      [self initializeAndLog];
    }
  }
  return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:NSApplicationDidFinishLaunchingNotification
                                                object:nil];
  [self initializeAndLog];
}

- (void)initializeAndLog {
  NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
  NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
  NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize {
  // Create menu items, initialize UI, etc.
  // Sample Menu Item:
  NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
  if (menuItem) {
    [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
    NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Comment Selection With //"
                                                            action:@selector(doMenuAction)
                                                     keyEquivalent:@""];
    //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
    [actionMenuItem setTarget:self];
    [[menuItem submenu] addItem:actionMenuItem];
    return YES;
  } else {
    return NO;
  }
}

// Sample Action, for menu item:
- (void)doMenuAction {
  NSRange selectedRange = [self.activeTextView selectedRange];
  if (!selectedRange.length) {
    /*[self.activeTextView moveToBeginningOfLine:nil];
    [self.activeTextView insertText:@"//"];
    [self.activeTextView moveToEndOfLine:nil];*/
    [self.activeTextView selectLine:nil];
    selectedRange = [self.activeTextView selectedRange];
    if (!selectedRange.length) {
      return;
    }

    NSMutableString *fullString = [[self.activeTextView string] mutableCopy];
    NSString *selectedString = [fullString substringWithRange:selectedRange];

    NSString *stringToReplace = [selectedString jk_isAcomment2]
                                    ? [selectedString jk_commentRemoved2String]
                                    : [selectedString jk_commented2String];

    if ([self.activeTextView shouldChangeTextInRange:selectedRange
                                   replacementString:stringToReplace]) {
      [[self.activeTextView textStorage] beginEditing];

      [[self.activeTextView textStorage] replaceCharactersInRange:selectedRange
                                                       withString:stringToReplace];
      [[self.activeTextView textStorage] endEditing];
      [self.activeTextView didChangeText];
    }
  } else {
    NSMutableString *fullString = [[self.activeTextView string] mutableCopy];
    NSString *selectedString = [fullString substringWithRange:selectedRange];

    NSString *stringToReplace = [selectedString jk_isAcomment]
                                    ? [selectedString jk_commentRemovedString]
                                    : [selectedString jk_commentedString];

    if ([self.activeTextView shouldChangeTextInRange:selectedRange
                                   replacementString:stringToReplace]) {
      [[self.activeTextView textStorage] beginEditing];

      [[self.activeTextView textStorage] replaceCharactersInRange:selectedRange
                                                       withString:stringToReplace];
      [[self.activeTextView textStorage] endEditing];
      [self.activeTextView didChangeText];
    }
  }
}

- (NSTextView *)activeTextView {
  NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
  if ([firstResponder isKindOfClass:NSClassFromString(@"DVTSourceTextView")] &&
      [firstResponder isKindOfClass:[NSTextView class]]) {
    _activeTextView = (NSTextView *)firstResponder;
  }
  return _activeTextView;
}

@end
