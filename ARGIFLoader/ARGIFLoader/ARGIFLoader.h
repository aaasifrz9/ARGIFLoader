//
//  LoaderUtility.h
//  savezees
//
//  Created by Sunvera Software on 7/15/15.
//  Copyright (C) 2016 Sunvera Software / Savezees, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ORIGINAL,
    PERCENTAGE,
    FIXED
} ImageSizeOption;

static UIWindow* _currentWindow;
//Overlay

static UIView* _overlayView;
static UIColor* _overlayColor;
static float _overlayAlpha;
//Image
static UIImageView* _loaderImageView;
static UIImage* _loaderImage;
static float _loaderImageWidth, _loaderImageHeight, _loaderImageSizeInPercentageOfDeviceWidth;
static ImageSizeOption imageSizeOption;



@interface ARGIFLoader : NSObject


#pragma mark - Set 1 time atleast
+(void)setOverlayHEXColorCode:(NSString*)hexColorCode alpha:(float)alpha;

#pragma mark - Set Loader Image 1 time atleast any method
+(void)setLoaderImage:(UIImage*)image;
+(void)setLoaderImage:(UIImage*)image imageSizeInPercentageOfDeviceWidth:(float)imageSizeInPercentageOfDeviceWidth;
+(void)setLoaderImage:(UIImage*)image width:(float)imageWidth height:(float)imageHeight;

+(void)showLoaderWithOverlay;
+(void)showLoaderWithoutOverlay;
+(void)showOverlayOnly;

+(void)hideLoader;

@end
