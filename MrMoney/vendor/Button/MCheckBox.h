//
//  EICheckBox.h
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCheckBoxDelegate;

@interface MCheckBox : UIButton {
 
    BOOL _checked;
    id _userInfo;
}

@property(nonatomic, assign)id<MCheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, retain)id userInfo;

- (id)initWithDelegate:(id)delegate;

@end

@protocol MCheckBoxDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(MCheckBox *)checkbox checked:(BOOL)checked;

@end
