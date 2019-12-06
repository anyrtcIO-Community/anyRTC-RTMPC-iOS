//
//  UIViewController+PresentModel.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/12/4.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "UIViewController+PresentModel.h"

@implementation UIViewController (PresentModel)

+ (void)load
{
    Method carshMethod = class_getInstanceMethod([self class], @selector(presentViewController: animated: completion:));
    Method newMethod = class_getInstanceMethod([self class], @selector(model_presentViewController: animated: completion:));
    method_exchangeImplementations(carshMethod, newMethod);
}

- (void)model_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.modalPresentationStyle == -2 || viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverFullScreen;
        }
    }
    [self model_presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
