//
//  DropDownListView.h
//  KDropDownMultipleSelection
//
//  Created by xingyong on 03/01/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//


@protocol MDropDownListViewDelegate;

@interface MDropDownListView : UIView<UITableViewDataSource,UITableViewDelegate>{

    UITableView *_tableView;
    
    NSString *titleText;
 
    CGFloat R,G,B,A;
   
    
}

@property(nonatomic,strong)NSArray *arrayList;

@property (nonatomic, assign) id<MDropDownListViewDelegate> delegate;


- (void)fadeOut;
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions xy:(CGPoint)point size:(CGSize)size;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end

@protocol MDropDownListViewDelegate <NSObject>
- (void)dropDownListView:(MDropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex;
@optional
- (void)dropDownListView:(MDropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData;

@end
