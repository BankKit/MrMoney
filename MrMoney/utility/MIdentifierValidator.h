//
//  MIdentifierValidator.h
//  MrMoney
//
//  Created by xingyong on 14-4-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    IdentifierTypeKnown = 0,
    IdentifierTypeZipCode,      //1
    IdentifierTypeEmail,        //2
    IdentifierTypePhone,        //3
    IdentifierTypeUnicomPhone,  //4
    IdentifierTypeQQ,           //5
    IdentifierTypeNumber,       //6
    IdentifierTypeString,       //7
    IdentifierTypeIdentifier,   //8
    IdentifierTypePassort,      //9
    IdentifierTypeCreditNumber, //10
    IdentifierTypeBirthday,     //11
}IdentifierType;

@interface MIdentifierValidator : NSObject
+ (BOOL) isValid:(IdentifierType) type value:(NSString*) value;
@end
