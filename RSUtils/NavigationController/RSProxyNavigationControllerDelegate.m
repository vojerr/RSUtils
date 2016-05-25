//
//  RSProxyNavigationControllerDelegate.m
//  RSProxyingDelegate
//
//  Created by Ruslan Samsonov on 5/25/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

#import "RSProxyNavigationControllerDelegate.h"

@implementation RSProxyNavigationControllerDelegate
- (instancetype)initWithDelegate:(id <UINavigationControllerDelegate>)delegate
{
    _delegate = delegate;
    return self;
}

#pragma mark - Invocations
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_delegate methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:_delegate];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (aSelector == @selector(navigationController:didShowViewController:animated:)) {
        return YES;
    }
    return [_delegate respondsToSelector:aSelector];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [_delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    if (_didShowBlock) {
        _didShowBlock();
    }
}
@end
