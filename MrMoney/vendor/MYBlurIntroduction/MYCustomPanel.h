//
//  MYCustomPanel.h
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/17/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYIntroductionPanel.h"

@interface MYCustomPanel : MYIntroductionPanel {
    
}
@property(nonatomic,weak)IBOutlet UIImageView *imageView;
@property(nonatomic,weak)IBOutlet UIButton *introductionBtn;

- (IBAction)didPressEnable:(id)sender;

@end
