//
//  MSMainViewController.m
//  LiveBlurDemo
//
//  Created by Michael Spensieri on 3/21/14.
//  Copyright (c) 2014 Michael Spensieri. All rights reserved.
//

#import "MSMainViewController.h"
#import "time.h"
#import "MSLiveBlurView.h"

static const CGFloat kTimerInterval = 0.3;
static const CGFloat kSliderWidth = 200;

@interface MSMainViewController()

@property NSMutableArray* textLabels;
@property MSLiveBlurView* blurView;
@property UISlider* slider;

@end

@implementation MSMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initTextLabels];
    [self initSlider];
    
    self.blurView = [[MSLiveBlurView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
   [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    srand(time(NULL));
}

-(void)initTextLabels
{
    self.textLabels = [NSMutableArray new];
    
    NSArray* labelTitles = [@"Hi I'm Mike. Drag the blurred area to see something cool" componentsSeparatedByString:@" "];
    
    for(int i = 0; i < labelTitles.count; i++){
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20 + 90*(i % 3), 40 + 110*(i / 3), 500, 100)];
        label.text = labelTitles[i];
        label.font = [UIFont systemFontOfSize:15];
        [label sizeToFit];
        
        [self.view addSubview:label];
        
        [self.textLabels addObject:label];
    }
}

-(void)initSlider
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, kSliderWidth, 40)];
    self.slider.center = CGPointMake(self.view.center.x, self.slider.center.y);
    self.slider.value = 0.5;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
}

-(void)sliderValueChanged:(UISlider *)sender {
    self.blurView.blurRadius = 10 * sender.value;
}

-(void)onPan:(UIPanGestureRecognizer*)sender
{
    if(sender.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [sender translationInView:sender.view];
        self.blurView.frame = CGRectOffset(self.blurView.frame, translation.x, translation.y);
        [sender setTranslation:CGPointZero inView:sender.view];
    }
}

-(void)changeColor
{
    for(UILabel* label in self.textLabels){
        label.textColor = [UIColor colorWithRed:[self randomFloat] green:[self randomFloat] blue:[self randomFloat] alpha:1.0];
    }
}

-(float)randomFloat
{
    return (float)rand() / (float)RAND_MAX;
}

@end
