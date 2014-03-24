//
//  UIColor+MCategory.m
//  MrMoney
//
//  Created by xingyong on 14-1-24.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "UIColor+MCategory.h"

@implementation UIColor (MCategory)

+ (UIColor *)fromHexString:(NSString *)hexString
{
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if(hexString.length == 3)
    {
        const char *temp = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
        const unsigned short t[] = {temp[0], temp[0], temp[1], temp[1], temp[2], temp[2]};
        hexString = [NSString stringWithCharacters:t length:6];
    }
    
	UIColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != hexString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:hexString];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	
    result      = [UIColor
                   colorWithRed: (float)redByte	 / 0xff
                   green:        (float)greenByte / 0xff
                   blue:         (float)blueByte	 / 0xff
                   alpha:1.0];
    
	return result;
    
}

+ (UIColor *)randomColor
{
    return [UIColor
            colorWithRed:((CGFloat)random()/(CGFloat)RAND_MAX)
            green:((CGFloat)random()/(CGFloat)RAND_MAX)
            blue:((CGFloat)random()/(CGFloat)RAND_MAX)
            alpha:1.0f];
}

- (UIColor *)colorByChangingAlphaTo:(CGFloat)alpha
{
    CGFloat *oldComponents  = (CGFloat *)CGColorGetComponents([self CGColor]);
	int numComponents       = CGColorGetNumberOfComponents([self CGColor]);
	CGFloat newComponents[4];
    
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[0];
			newComponents[2] = oldComponents[0];
			newComponents[3] = alpha;
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[1];
			newComponents[2] = oldComponents[2];
			newComponents[3] = alpha;
			break;
		}
	}
    
	CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor         = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *color = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
	return color;
}

- (UIColor *)invertColor
{
    CGColorRef oldCGColor   = self.CGColor;
    int numberOfComponents  = CGColorGetNumberOfComponents(oldCGColor);
    
    if (numberOfComponents == 1)
        return [UIColor colorWithCGColor:oldCGColor];
    
    const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];
    
    int i = numberOfComponents - 1;
    newComponentColors[i] = oldComponentColors[i];
    
    while (--i >= 0)
        newComponentColors[i] = 1 - oldComponentColors[i];
    
    CGColorRef newCGColor   = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor *newColor       = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);
    
    return newColor;
    
}

@end


