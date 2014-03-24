//
//  DropDownListView.h
//  KDropDownMultipleSelection
//
//  Created by macmini17 on 03/01/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

@class MPayView;
@protocol kDropDownListViewDelegate;
@interface DropDownListView : UIView<UITableViewDataSource,UITableViewDelegate>{

    UITableView *_tableView;
    NSString *_kTitleText;
    NSArray *_kDropDownOption;
    CGFloat R,G,B,A;
    BOOL isMultipleSelection;
    UIControl   *_overlayView;
}
@property(nonatomic,strong)NSMutableArray *arryData;
@property(nonatomic,strong)MPayView *payView;
 
@property (nonatomic, assign) id<kDropDownListViewDelegate> delegate;

- (void)fadeOut;
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end

@protocol kDropDownListViewDelegate <NSObject>
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex;
- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData;
- (void)DropDownListViewDidButtonClick:(float )money bankId:(NSString *)bank_id;
@end
