//
//  ViewController.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/20.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "WFElasticityView.h"
#import "WFWaveHeader.h"
#import "WFSubViewController.h"
#import "WFMainTabbarViewController.h"
#import "WFPresentationController.h"
#import "WFSecondViewController.h"
#import "WFPhotoBrowseViewController.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>
#import "WFEmitterAnimationView.h"
#import <AVFoundation/AVFoundation.h>
#import "WFAnimationInteractionView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <objc/runtime.h>

@class Test;
@protocol testDelegate <NSObject>

- (void)test:(Test *)test;

@end

@interface Test : NSObject
- (void)teset;
@property(copy,nonatomic)void(^block)(void);
@property(weak,nonatomic) id<testDelegate> delegate;
@end

@implementation Test

- (void)teset{
    if (self.block) {
        self.block();
    }
    
    if ([self.delegate respondsToSelector:@selector(test:)]) {
        [self.delegate test:self];
        NSLog(@"-------%@",self);
    }
}

@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,AVAudioRecorderDelegate,testDelegate>
/** tableView */
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) AVPlayer *audioPlayer;
@property(nonatomic, strong) AVAudioRecorder *audioRecorder;
@property(nonatomic, copy) NSString *audioPath;
@end

@implementation ViewController

- (void)test:(Test *)test{
    test = nil;
}

- (void)test{
    NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_test) name:@"123" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"123" object:nil queue:queue usingBlock:^(NSNotification * _Nonnull note) {
        
    }];
}

- (void)viewDidLoad {
    
    __block Test *test = [[Test alloc] init];
    NSLog(@"----%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(test)));
    test.delegate = self;
//    test.block = ^{
//        test = nil;
//    };
    [test teset];
    
    [super viewDidLoad];
    self.navigationItem.title = @"动画";
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_queue_set_specific(mainQueue, "key", "main", NULL);
    dispatch_sync(globalQueue, ^{
        BOOL res1 = [NSThread isMainThread];
        BOOL res2 = dispatch_get_specific("key") != NULL;
        
        NSLog(@"is main thread: %d --- is main queue: %d", res1, res2);
    });
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:@{@"ds":@"12",@"3b":@"64",@"f9g":@"99"}];
    [temp addEntriesFromDictionary:@{@"d":@"4"}];
    [temp addEntriesFromDictionary:@{@"dds":@"4"}];[temp addEntriesFromDictionary:@{@"ddd":@"4"}];[temp addEntriesFromDictionary:@{@"sdfa":@"4"}];[temp addEntriesFromDictionary:@{@"xcv":@"4"}];[temp addEntriesFromDictionary:@{@"wd":@"4"}];[temp addEntriesFromDictionary:@{@"ddfg":@"4"}];[temp addEntriesFromDictionary:@{@"dgte":@"4"}];
    NSLog(@"----%@",temp.allKeys.firstObject);
    
    self.view.backgroundColor = [UIColor orangeColor];
//    NSURL *url = [NSURL URLWithString:@"https://hwstatic.qiu-ai.com/haiwan/clientSource/voicePassed/15794878264621/1590033484546.amr"];
//    _audioPlayer = [[AVPlayer alloc] initWithURL:url];
//    [_audioPlayer play];
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 50, 20)];
    mask.backgroundColor = [UIColor greenColor];
    mask.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    mask.layer.borderWidth = 5.f;
    [self.view addSubview:mask];
    
//    WFAnimationInteractionView *view = [[WFAnimationInteractionView alloc] initWithFrame:CGRectMake(0, 120, 100, 50)];
//    view.backgroundColor = [UIColor redColor];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.backgroundColor = [UIColor orangeColor];
//    [view addSubview:button];
//    [button setTitle:@"点击一下" forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, 100, 20);
//    [button addTarget:self action:@selector(p_click) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:button];
//    [self.view addSubview:view];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_click)];
//    [view addGestureRecognizer:tap];
    
//    [UIView animateWithDuration:15 animations:^{
//        view.frame = CGRectMake(0, 520, 100, 50);
//    }];
                                                                        
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.roation.z"];
//    animation.duration = 10;
//    animation.repeatCount = 100;
//    animation.autoreverses = YES;
//    animation.removedOnCompletion = NO;
//    animation.cumulative = YES;
//    animation.toValue = [NSNumber numberWithFloat:M_PI_2 * 2];
//    [view.layer addAnimation:animation forKey:@"roation"];
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"scale"];
//    animation.values = @[@(0.1), @(1.1), @(0.9), @(1)];
//    animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
//    animation.repeatCount = 100;
//    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    animation.duration = 0.5;
//    [view.layer addAnimation:animation forKey:@"scale"];

//    [UIView animateWithDuration:1 animations:^{
//        view.transform  = CGAffineTransformMakeTranslation(0, 50);
//    } completion:^(BOOL finished) {
//        view.transform = CGAffineTransformIdentity;
//    }];
    
//    WFEmitterAnimationView *emitterView = [[WFEmitterAnimationView alloc] initWithFrame:UIScreen.mainScreen.bounds];
//    [self.view addSubview:emitterView];
    
    [self createDisplayView];
    
//    NSLog(@"测试%zd",@"-1".integerValue);
    
//    NSDate *today = [NSDate date];
//    NSDate *compareDay = nil;
//    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    NSString *beginDate = @"2019-03-15 18:23:12";
//    if (beginDate) {
//        compareDay = [dateFormater dateFromString:beginDate];
//        if ([compareDay compare:today] == NSOrderedDescending) {
//            NSLog(@"%@大于%@",compareDay,today);
//        }else if ([compareDay compare:today] == NSOrderedAscending){
//            NSLog(@"%@小于%@",compareDay,today);
//        }else{
//        }
//    }
    
        // 创建一个按钮
       UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       // 设置按钮的frame
       btn.frame = CGRectMake(100, 300, 200, 50);
       // 加载图片
       UIImage *image = [UIImage imageNamed:@"heheda"];
       // 设置左边端盖宽度
       NSInteger leftCapWidth = image.size.width * 0.5;
       // 设置上边端盖高度
       NSInteger topCapHeight = image.size.height * 0.5;
       [btn addTarget:self action:@selector(stopRecod) forControlEvents:UIControlEventTouchUpInside];
       UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
       
       // 设置按钮的背景图片
       [btn setBackgroundImage:newImage forState:UIControlStateNormal];
       
       // 将按钮添加到控制器的view
       [self.view addSubview:btn];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"heheda"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 100, 50, 50);
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height +10 ,-button.imageView.frame.size.width, 0.0,0.0)];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0.0,0.0, -button.titleLabel.intrinsicContentSize.width)];
//    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [button setTitle:@"测试" forState:UIControlStateNormal];
//    [self.view addSubview:button];
//
//    UIButton *effect = [UIButton buttonWithType:UIButtonTypeCustom];
//    [effect setImage:[UIImage imageNamed:@"heheda"] forState:UIControlStateNormal];
//    effect.frame = CGRectMake(110, 130, 60, 85);
//    effect.titleEdgeInsets = UIEdgeInsetsMake(effect.imageView.frame.size.width + 10, -effect.imageView.frame.size.width, 0, 0);
//    effect.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -effect.titleLabel.intrinsicContentSize.width);
//    effect.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [effect setTitle:@"测试特效" forState:UIControlStateNormal];
//    [effect setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.view addSubview:effect];
//
//    NSString *test = @"{\"go\":\"live_1004\",\"link\":{\"type\":\"test\"}}";
//    NSData *jsonData = [test dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *_imageURL = @"http://hnstatic.qiu-ai.com/pro/320/icon1594033938737.png";
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,100, 200, 200)];
    backImage.clipsToBounds = YES;
    [self.view addSubview:backImage];
    UIImage *dataImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
    backImage.image = [self grayImage:dataImage];
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
       
       //设置抖动幅度
       shake.fromValue = [NSNumber numberWithFloat:-0.2];
       
       shake.toValue = [NSNumber numberWithFloat:+0.2];
       
       shake.duration = 0.5;
       
       shake.autoreverses = YES; //是否重复
       
       shake.repeatCount = HUGE_VAL;
       
       [backImage.layer addAnimation:shake forKey:@"imageView"];
       
       
//       [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
}

- (UIImage *)grayImage:(UIImage *)sourceImage{
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}
    
- (void)p_click{
    NSURL *url = [NSURL URLWithString:self.audioPath];
    _audioPlayer = [[AVPlayer alloc] initWithURL:url];
    [_audioPlayer play];
    NSLog(@"开始播放%@",self.audioPath);
}

#pragma mark - 曲线动画
- (void)createDisplayView{
    self.view.backgroundColor = [UIColor lightGrayColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    _tableView = tableView;

    for (int i = 0; i < 20; i ++) {
        [self.dataArray addObject:@"1"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
//    WFWaveHeader *header = [[WFWaveHeader alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, 100) backgroundColor:[UIColor yellowColor] beforColor:[UIColor purpleColor]];
//    tableView.tableHeaderView = header;
//    
//    WFElasticityView *v1 = [[WFElasticityView alloc] initWithBlindScrollView:_tableView];
//    v1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:v1];
//    [tableView addSubview:v1];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
//        if (status == AVPlayerItemStatusReadyToPlay) {
//            // 资源准备好了，可以进行播放
//            NSLog(@"资源准备好了，可以进行播放");
//        }else{
//            NSLog(@"状态未知");
//        }
//    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
//        BOOL pToKeepUp = [change[NSKeyValueChangeNewKey] boolValue];
//        if (pToKeepUp) {
//            // 这里是指有可缓冲好的资源去播放
//            NSLog(@"资源已经准备好了,可以进行播放");
//        }else{
//            NSLog(@"资源准备中，也就是在正在加载");
//        }
//    }
//}

- (void)creatHeaderDragAnimation{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((K_Screen_Width - 30) * 0.5, 250);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 140, K_Screen_Width, K_Screen_Height - 64 - 140) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    _collectionView = collectionView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 20; i ++) {
            [self.dataArray addObject:@"1"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            cell.transform = CGAffineTransformMakeRotation(0.1);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                cell.transform = CGAffineTransformMakeRotation(-0.1);
            }];
        });
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"refresh";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    if (@available(iOS 14.0, *)) {
        UIListContentConfiguration *configuration = UIListContentConfiguration.subtitleCellConfiguration;
        configuration.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
        configuration.image = [UIImage imageNamed:@"heheda"];
        cell.contentConfiguration = configuration;
    } else {
        // Fallback on earlier versions
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WFSecondViewController *secondVC = [WFSecondViewController new];
    WFPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[WFPresentationController alloc] initWithPresentedViewController:secondVC presentingViewController:nil];
    secondVC.transitioningDelegate = presentationController;
    [self presentViewController:secondVC animated:YES completion:nil];
    
//    WFPhotoBrowseViewController *photo = [[WFPhotoBrowseViewController alloc] init];
//    [self presentViewController:photo animated:YES completion:nil];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    WFSubViewController *VC = [WFSubViewController new];
//    [self presentViewController:VC animated:YES completion:NULL];
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//
//    }];
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//
//    }];
//    [self presentViewController:alertVC animated:YES completion:nil];
//}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//    if (!*guard) return;  // Duplicate the guard check.
//
//    void *PC = __builtin_return_address(0);
//    Dl_info info;
//    dladdr(PC, &info);
//
//    printf("fname=%s \nfbase=%p \nsname=%s\nsaddr=%p \n",info.dli_fname,info.dli_fbase,info.dli_sname,info.dli_saddr);
//
//    char PcDescr[1024];
//    printf("guard: %p %x PC %s\n", guard, *guard, PcDescr);
//}

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                         uint32_t *stop) {
    static uint64_t N;  // Counter for the guards.
    if (start == stop || *start) return;  // Initialize only once.
    printf("INIT: %p %p\n", start, stop);
    for (uint32_t *x = start; x < stop; x++)
        *x = ++N;  // Guards should start from 1.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_audioPlayer play];
    WFSecondViewController *vc = [WFSecondViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];

    [self recordVoice];
    
//    NSMutableArray<NSString *> * symbolNames = [NSMutableArray array];
//    while (true) {
//        //offsetof 就是针对某个结构体找到某个属性相对这个结构体的偏移量
//        SymbolNode * node = OSAtomicDequeue(&symboList, offsetof(SymbolNode, next));
//        if (node == NULL) break;
//        Dl_info info;
//        dladdr(node->pc, &info);
//
//        NSString * name = @(info.dli_sname);
//
//        // 添加 _
//        BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
//        NSString * symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
//
//        //去重
//        if (![symbolNames containsObject:symbolName]) {
//            [symbolNames addObject:symbolName];
//        }
//    }
//
//    //取反
//    NSArray * symbolAry = [[symbolNames reverseObjectEnumerator] allObjects];
//    NSLog(@"%@",symbolAry);
//
//    //将结果写入到文件
//    NSString * funcString = [symbolAry componentsJoinedByString:@"\n"];
//    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"lb.order"];
//    NSData * fileContents = [funcString dataUsingEncoding:NSUTF8StringEncoding];
//    BOOL result = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
//    if (result) {
//        NSLog(@"%@",filePath);
//    }else{
//        NSLog(@"文件写入出错");
//    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
}

//原子队列
static OSQueueHead symboList = OS_ATOMIC_QUEUE_INIT;
//定义符号结构体
typedef struct{
    void * pc;
    void * next;
}SymbolNode;

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    //if (!*guard) return;  // Duplicate the guard check.
    
    void *PC = __builtin_return_address(0);
    
    SymbolNode * node = malloc(sizeof(SymbolNode));
    *node = (SymbolNode){PC,NULL};
    
    //入队
    // offsetof 用在这里是为了入队添加下一个节点找到 前一个节点next指针的位置
    OSAtomicEnqueue(&symboList, node, offsetof(SymbolNode, next));
}

- (void)recordVoice{
    //如果是在录音就不做动作
    if ([self.audioRecorder isRecording]) {
        return;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    NSMutableDictionary *audioSetting = [NSMutableDictionary dictionary];
    // 设置录音格式 kAudioFormatMPEGLayer3设置貌似是没用的 默认设置就行
    [audioSetting setObject:@(kAudioFormatMPEGLayer3) forKey:AVFormatIDKey];
    
    // 设置录音采样率，8000 44100 96000，对于一般录音已经够了
    [audioSetting setObject:@(22150) forKey:AVSampleRateKey];
    
    // 设置通道 1 2
    [audioSetting setObject:@(1) forKey:AVNumberOfChannelsKey];
    
    // 每个采样点位数,分为8、16、24、32
    [audioSetting setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    
    // 是否使用浮点数采样 如果不是MP3需要用Lame转码为mp3的一定记得设置NO！(不然转码之后的声音一直都是杂音)
    // 是否使用浮点数采样 如果不是MP3需要用Lame转码为mp3的一定记得设置NO！(不然转码之后的声音一直都是杂音)
    // 是否使用浮点数采样 如果不是MP3需要用Lame转码为mp3的一定记得设置NO！(不然转码之后的声音一直都是杂音)
    [audioSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    
    // 录音质量
    [audioSetting setObject:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
    
    //创建录音文件保存路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Cache/AudioData"];
    NSLog(@"%@",path);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",path);
    }
     //每次启动后都保存一个新的文件中
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    // 想要录制MP3格式的 这里 MP3 必须大写 ！！！！(苹果的所有后缀名都是大写，所以这是个坑)
    // 想要录制MP3格式的 这里 MP3 必须大写 ！！！！(苹果的所有后缀名都是大写，所以这是个坑)
    // 想要录制MP3格式的 这里 MP3 必须大写 ！！！！(苹果的所有后缀名都是大写，所以这是个坑)
    path = [path stringByAppendingFormat:@"/%@.MP3",dateStr];
    self.audioPath = path;
    NSURL *url = [NSURL fileURLWithPath:path];
    //创建录音机
    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:audioSetting error:&error];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
    if (error) {
        NSLog(@"创建录音机时发生错误，信息：%@",error.localizedDescription);
    }else{
        if (![self.audioRecorder isRecording]) {
            NSLog(@"录音开始");
            [self.audioRecorder record];
        }
    }
}

- (void)stopRecod{
    [self.audioRecorder stop];
    NSLog(@"暂定录音");
}

@end
