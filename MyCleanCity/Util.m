//
//  Util.m
//  MyCleanCity
//
//  Created by fliptoo on 3/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "Util.h"
#import <ImageIO/ImageIO.h>
#include <sys/xattr.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation Util

+ (NSData *)dataFromImage:(UIImage *)image metadata:(NSDictionary *)metadata mimetype:(NSString *)mimetype
{
    NSMutableData *imageData = [NSMutableData data];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)mimetype, NULL);
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, uti, 1, NULL);
    
    if (imageDestination == NULL)
    {
        NSLog(@"Failed to create image destination");
        imageData = nil;
    }
    else
    {
        CGImageDestinationAddImage(imageDestination, image.CGImage, (__bridge CFDictionaryRef)metadata);
        
        if (CGImageDestinationFinalize(imageDestination) == NO)
        {
            NSLog(@"Failed to finalise");
            imageData = nil;
        }
        CFRelease(imageDestination);
    }
    
    CFRelease(uti);
    
    return imageData;
}

+ (NSString *)feasibility:(int)value {
    if (value == 3) {
        return @"Requires more than 3 Years";
    } else if (value == 2) {
        return @"Can be implemented within 1 to 2 Years";
    } else {
        return @"Can be implemented immediately";
    }
}

@end
