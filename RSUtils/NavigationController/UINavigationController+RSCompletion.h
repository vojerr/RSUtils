//
//  UINavigationController+RSCompletion.h
//  RSProxyingDelegate
//
//  Created by Ruslan Samsonov on 5/25/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (RSCompletion)
- (void)rs_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)rs_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
@end
