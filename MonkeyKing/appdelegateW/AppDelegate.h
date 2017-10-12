//
//  AppDelegate.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager* _mapManager;
    ViewController *_mainController;
}

@property (strong, nonatomic) UIWindow *window;


@end

