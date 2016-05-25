//
//  UINavigationController+RSCompletion.m
//  RSProxyingDelegate
//
//  Created by Ruslan Samsonov on 5/25/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

#import "UINavigationController+RSCompletion.h"
#import "RSProxyNavigationControllerDelegate.h"
#import <objc/runtime.h>

@implementation UINavigationController (RSCompletion)

- (void)rs_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self applyProxyDelegateWithCompletion:completion];
    [self pushViewController:viewController animated:animated];
}

- (void)rs_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self applyProxyDelegateWithCompletion:completion];
    [self popViewControllerAnimated:animated];
}

#pragma mark - Proxying
static char proxyDelegateKey;

- (void)applyProxyDelegateWithCompletion:(void (^)(void))completion
{
    RSProxyNavigationControllerDelegate *proxyDelegate = [[RSProxyNavigationControllerDelegate alloc] initWithDelegate:self.delegate];
    proxyDelegate.didShowBlock = ^ {
        RSProxyNavigationControllerDelegate *associatedProxyDelegate = objc_getAssociatedObject(self, &proxyDelegateKey);
        self.delegate = associatedProxyDelegate.delegate;
        objc_setAssociatedObject(self, &proxyDelegateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (completion) {
            completion();
        }
    };
    objc_setAssociatedObject(self, &proxyDelegateKey, proxyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = proxyDelegate;
}
@end
