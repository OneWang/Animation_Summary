//
//  WFEmitterAnimationView.m
//  Animation_Summary
//
//  Created by Jack on 2020/5/11.
//  Copyright © 2020 Jack. All rights reserved.
//

#import "WFEmitterAnimationView.h"

@interface WFEmitterAnimationView ()

@property(nonatomic, strong) CAEmitterLayer *emitterLayer;

@end

@implementation WFEmitterAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self p_createChildViews];
        self.backgroundColor = [UIColor redColor];
        
        
    }
    return self;
}

- (void)p_createChildViews{
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"heheda"].CGImage);
    emitterCell.birthRate = 20;
    emitterCell.lifetime = 5.f;
    emitterCell.lifetimeRange = 0.3;
//    emitterCell.alphaRange = 0.4;
//    emitterCell.alphaSpeed = -0.2;
    emitterCell.velocity = 200;
    emitterCell.velocityRange = 20;
    emitterCell.redRange = 0.5;
    emitterCell.greenRange = 0.5;
    emitterCell.blueRange = 0.5;
    emitterCell.scale = 0.1;
    emitterCell.scaleRange = 0.02;
    emitterCell.emissionRange = 0.5 * M_PI;
    emitterCell.emissionLongitude = M_PI;
    ///y 方向上的加速度
    emitterCell.yAcceleration = 200.0;
//    emitterCell.xAcceleration = 50;
    
    _emitterLayer = [CAEmitterLayer layer];
    //发射位置
    _emitterLayer.emitterPosition = CGPointMake(UIScreen.mainScreen.bounds.size.width/2.0, 0);
      //粒子产生系数，默认为1
    _emitterLayer.birthRate = 1;
      //发射器的尺寸
    _emitterLayer.emitterSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 0);
      //发射的形状
    _emitterLayer.emitterShape = kCAEmitterLayerLine;
      //发射的模式
    _emitterLayer.emitterMode = kCAEmitterLayerSurface;
      //渲染模式
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    _emitterLayer.masksToBounds = NO;
      //_emitterLayer.zPosition = -1;
    _emitterLayer.emitterCells = @[emitterCell];
    //emitterView是自己创建的一个View
    [self.layer addSublayer:_emitterLayer];
}

@end
