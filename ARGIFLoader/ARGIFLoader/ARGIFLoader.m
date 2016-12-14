//
//  LoaderUtility.m
//  savezees
//
//  Created by Sunvera Software on 7/15/15.
//  Copyright (C) 2016 Sunvera Software / Savezees, Inc. All rights reserved.
//
#import "ARGIFLoader.h"
#import "AppDelegate.h"
#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@implementation ARGIFLoader

+(void)setOverlayHEXColorCode:(NSString*)hexColorCode alpha:(float)alpha{
    _overlayColor = [self colorWithHexString:hexColorCode];
    _overlayAlpha = alpha;
}

+(void)setLoaderImage:(UIImage*)image{
    imageSizeOption = ORIGINAL;
    _loaderImage = image;
}

+(void)setLoaderImage:(UIImage*)image imageSizeInPercentageOfDeviceWidth:(float)imageSizeInPercentageOfDeviceWidth{
    imageSizeOption = PERCENTAGE;
    
    _loaderImageSizeInPercentageOfDeviceWidth = imageSizeInPercentageOfDeviceWidth;
    _loaderImage = image;
}

+(void)setLoaderImage:(UIImage*)image width:(float)imageWidth height:(float)imageHeight{
    imageSizeOption = FIXED;
    
    _loaderImage = image;
    _loaderImageWidth = imageWidth;
    _loaderImageHeight = imageHeight;
}

+(void)showLoaderWithOverlay{
    
    [self setupOverlay];
    
    UIImageView *overlayImageView =[[UIImageView alloc ]initWithFrame:APPDELEGATE.window.frame];
    overlayImageView.backgroundColor = _overlayColor == nil ? [UIColor blackColor] : _overlayColor;
    overlayImageView.alpha = _overlayAlpha == 0.0f ? 0.8f : _overlayAlpha;
    
    [self setLoaderImageFrame];
    
    [_overlayView addSubview:overlayImageView];
    [_overlayView addSubview:_loaderImageView];
    [APPDELEGATE.window addSubview:_overlayView];
    [APPDELEGATE.window bringSubviewToFront:_overlayView];
    
    APPDELEGATE.window.userInteractionEnabled = NO;
    
    _overlayView.layer.zPosition = 50;
    [self rotateLoaderImage];
}


+(void)showLoaderWithoutOverlay{
    
    [self setupOverlay];
    
    [self setLoaderImageFrame];
    
    [_overlayView addSubview:_loaderImageView];
    [APPDELEGATE.window addSubview:_overlayView];
    [APPDELEGATE.window bringSubviewToFront:_overlayView];
    
    APPDELEGATE.window.userInteractionEnabled = NO;
    
    _overlayView.layer.zPosition = 50;
    [self rotateLoaderImage];
}

+(void)showOverlayOnly{
    
    [self setupOverlay];
    
    UIImageView *overlayImageView = [[UIImageView alloc] init];
    overlayImageView.frame = _overlayView.frame;
    overlayImageView.backgroundColor = _overlayColor == nil ? [UIColor blackColor] : _overlayColor;
    overlayImageView.alpha = _overlayAlpha == 0.0f ? 0.8f : _overlayAlpha;
    
    [_overlayView addSubview:overlayImageView];
    [_overlayView addSubview:_loaderImageView];
    [APPDELEGATE.window addSubview:_overlayView];
    [APPDELEGATE.window sendSubviewToBack:_overlayView]; //Call this only with AlertController
}

+(void)setupOverlay{
    _overlayView = [[UIView alloc ]initWithFrame:APPDELEGATE.window.frame];
    _overlayView.backgroundColor = [UIColor clearColor];
}

+(void)hideLoader{
    APPDELEGATE.window.userInteractionEnabled = YES;
    
    [_loaderImageView.layer removeAnimationForKey:@"LoaderIcon"];
    [_loaderImageView removeFromSuperview];
    [_overlayView removeFromSuperview];
    _loaderImageView = nil;
    _overlayView = nil;
}

+ (void)rotateLoaderImage
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 2.0f;
    animation.repeatCount = INFINITY;
    [_loaderImageView.layer addAnimation:animation forKey:@"LoaderIcon"];
}

+(void)appWillEnterForeground:(NSNotification*)notification
{
    [self rotateLoaderImage];
}

+(void)setLoaderImageFrame{
    
    //Add Observer to rotate loader when app will enter foreground from background
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:@"UIApplicationWillEnterForegroundNotification"
                                               object:nil];
    
    _loaderImageView = [[UIImageView alloc] initWithImage:_loaderImage];
    
    switch (imageSizeOption) {
        case ORIGINAL:{
            _loaderImageView.frame = CGRectMake((APPDELEGATE.window.frame.size.width / 2) - (_loaderImageView.frame.size.width / 2), (APPDELEGATE.window.frame.size.height / 2) - (_loaderImageView.frame.size.height / 2), _loaderImageView.frame.size.width, _loaderImageView.frame.size.height);
            break;
        }
        case PERCENTAGE:{
            float scaleFactor = _loaderImage.size.width / _loaderImage.size.height;
            float newImageWidth = APPDELEGATE.window.frame.size.width * _loaderImageSizeInPercentageOfDeviceWidth;
            float newImageHeight = APPDELEGATE.window.frame.size.width * _loaderImageSizeInPercentageOfDeviceWidth * scaleFactor;
            
            _loaderImageView.frame = CGRectMake((APPDELEGATE.window.frame.size.width / 2) - (newImageWidth / 2), (APPDELEGATE.window.frame.size.height / 2) - (newImageHeight / 2), newImageWidth, newImageHeight);
            break;
        }
        case FIXED:{
            _loaderImageView.frame = CGRectMake((APPDELEGATE.window.frame.size.width / 2) - (_loaderImageWidth / 2), (APPDELEGATE.window.frame.size.height / 2) - (_loaderImageHeight / 2), _loaderImageWidth, _loaderImageHeight);
            break;
        }
        default:
            break;
    }
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
