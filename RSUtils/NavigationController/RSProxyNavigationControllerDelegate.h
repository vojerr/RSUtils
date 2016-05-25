//
//  RSProxyNavigationControllerDelegate.h
//  RSProxyingDelegate
//
//  Created by Ruslan Samsonov on 5/25/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RSProxyNavigationControllerDelegate : NSProxy <UINavigationControllerDelegate>
@property (nonatomic, weak, readonly) NSObject<UINavigationControllerDelegate> *delegate;
@property (nonatomic, copy) void(^didShowBlock)();

- (instancetype)initWithDelegate:(id <UINavigationControllerDelegate>)delegate;
@end
