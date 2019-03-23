//
//  WFParabolaAnimation.h
//  Animation_Summary
//
//  Created by Jack on 2019/3/22.
//  Copyright © 2019 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFParabolaAnimation : NSObject

+ (void)addParabolaAnimation:(UIImage *)animationView startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint completion:(void (^)(BOOL))completion;

@end

NS_ASSUME_NONNULL_END
