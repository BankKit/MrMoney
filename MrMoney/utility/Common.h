//
//  Common.h
//  CoolTable
//
//  Created by Edward on 13-6-16.
//  Copyright (c) 2013年 Lihang. All rights reserved.
//

#import <Foundation/Foundation.h>


//Define a global function we'll about to write
void drawLinearGradient(CGContextRef context,CGRect rect,CGColorRef startColor,CGColorRef endColor);

//反锯齿
CGRect rectFor1PxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);


//透明遮罩
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

static inline double radians (double degress) {return degress * M_PI/180;}
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);
