//
//  BagScrollItemUIViewController.h
//  ChipmunkWrapper
//
//  Created by Mac on 13/06/12.
//  Copyright (c) 2012 Sodeso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagScrollItemUIViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *powerImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *backgroundPath;
@property (weak, nonatomic) IBOutlet UIImageView *motifImage;

@end
