//
//  UIViewController+PresentModel.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/12/4.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "UIViewController+PresentModel.h"
#import <objc/runtime.h>

@implementation UIViewController (PresentModel)

+ (void)load
{
    Method carshMethod = class_getInstanceMethod([self class], @selector(presentViewController: animated: completion:));
    Method newMethod = class_getInstanceMethod([self class], @selector(model_presentViewController: animated: completion:));
    method_exchangeImplementations(carshMethod, newMethod);
}

- (void)model_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    //拍照会崩溃，必须放在主线程上
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 13.0, *)) {
            if (viewControllerToPresent.modalPresentationStyle == -2 || viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
                //导致dismiss以后前一个controller的viewWillAppear:不走
                //viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverFullScreen;
                viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
            }
        }
        [self model_presentViewController:viewControllerToPresent animated:flag completion:completion];
    });
}


@end
