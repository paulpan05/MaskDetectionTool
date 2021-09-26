//
//  AppDelegate.m
//  MaskDetectionTool
//
//  Created by Paul Pan on 21/09/26.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property NSWindow * _Nonnull window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, NSScreen.mainScreen.frame.size.width, NSScreen.mainScreen.frame.size.height) styleMask:(NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled) backing:NSBackingStoreBuffered defer:false];
    
    self.window.title = @"Mask Detection Tool";
    self.window.contentViewController = [[ViewController alloc] init];
    [self.window makeKeyAndOrderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
