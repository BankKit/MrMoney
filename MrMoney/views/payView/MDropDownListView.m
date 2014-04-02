//
//  DropDownListView.m
//  KDropDownMultipleSelection
//
//  Created by xingyong on 03/01/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import "MDropDownListView.h"
#import "MDropDownViewCell.h"
#import "MBankView.h"

#define DROPDOWNVIEW_HEADER_HEIGHT 40


@interface MDropDownListView (private)
- (void)fadeIn;
- (void)fadeOut;
@end
@implementation MDropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions xy:(CGPoint)point size:(CGSize)size
{
    
    CGRect rect = CGRectMake(point.x, point.y,size.width,size.height);
    
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        titleText = [aTitle copy];

        self.arrayList = aOptions;
         
        MBankView *bankView = [[[NSBundle mainBundle] loadNibNamed:@"MBankView" owner:self options:nil] lastObject];
        bankView.frame = rect;
        [bankView.backBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DROPDOWNVIEW_HEADER_HEIGHT, 300, 240 - DROPDOWNVIEW_HEADER_HEIGHT)];
        
        _tableView.rowHeight = 50.;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [bankView addSubview:_tableView];
        
        [self addSubview:bankView];
 
        
    }
    return self;
}

#pragma mark -------------  fadeIn -----------------

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
  
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated{
    
    [aView addSubview:self];
    
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    MDropDownViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==nil) {
        cell = [[MDropDownViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    
    int row = [indexPath row];
    
    NSString *bankOrderkey =  [_arrayList safeObjectAtIndex:row];
    
    NSDictionary *cellDict = [KPAY_DICT objectForKey:bankOrderkey];
    cell.imageView.image = bankLogoImage([cellDict objectForKey:@"bank"]);
    cell.textLabel.text = [cellDict objectForKey:@"name"];
    if (row == 0) {
        
        cell.detailTextLabel.text = STRING_FORMAT(@"%@%@",[cellDict objectForKey:@"content"],titleText);
    }else{
        cell.detailTextLabel.text =[cellDict objectForKey:@"content"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate  respondsToSelector:@selector(dropDownListView:didSelectedIndex:)]) {
        [self.delegate dropDownListView:self didSelectedIndex:[indexPath row]];
    }
    
    [self fadeOut];
    
	
}

@end
