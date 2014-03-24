//
//  MOrderData.h
//  MrMoney
//
//  Created by xingyong on 14-1-9.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseData.h"

@interface MOrderData : MBaseData

//盛付通参数
//@property (nonatomic,copy) NSString *  mBuyerContact;
//@property (nonatomic,copy) NSString *  mCharset;
//@property (nonatomic,copy) NSString *  mExt1 ;
//@property (nonatomic,copy) NSString *  mMsgSender;
//@property (nonatomic,copy) NSString *  mName ;
//@property (nonatomic,copy) NSString *  mNotifyUrl ;
//@property (nonatomic,copy) NSString *  mOrderNo;
//@property (nonatomic,copy) NSString *  mOrderTime ;
//@property (nonatomic,copy) NSString *  mPageUrl ;
//@property (nonatomic,copy) NSString *  mPayChannel ;
//@property (nonatomic,copy) NSString *  mSendTime ;
//@property (nonatomic,copy) NSString *  mSignMsg ;
//@property (nonatomic,copy) NSString *  mSignType ;
//@property (nonatomic,copy) NSString *  mTranceNo ;
//@property (nonatomic,copy) NSString *  mVersion ;
//@property (nonatomic,copy) NSString *  mrechargeProdName;

//银生宝参数
@property (nonatomic,copy) NSString *mamount ;
@property (nonatomic,copy) NSString *massuredPay ;
@property (nonatomic,copy) NSString *mb2b ;
@property (nonatomic,copy) NSString *mbankCode ;
@property (nonatomic,copy) NSString *mcardAssured ;
@property (nonatomic,copy) NSString *mcommodity ;
@property (nonatomic,copy) NSString *mcurrencyType ;
@property (nonatomic,copy) NSString *mmac ;
@property (nonatomic,copy) NSString *mmerchantId ;
@property (nonatomic,copy) NSString *mmerchantUrl ;
@property (nonatomic,copy) NSString *mmessage ;
@property (nonatomic,copy) NSString *morderId ;
@property (nonatomic,copy) NSString *morderUrl ;
@property (nonatomic,copy) NSString *mremark ;
@property (nonatomic,copy) NSString *mresponseMode ;
@property (nonatomic,copy) NSString *mtime ;
@property (nonatomic,copy) NSString *mversion ;



@end
