//
//  ViewController.h
//  CalciPad
//
//  Created by Administrator on 22.01.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UIImageView * topView;
    UIMenuController * menu;
    BOOL isMemoryVisible;
}

- (IBAction)resultLabelTap:(UITapGestureRecognizer *)sender;

@end
