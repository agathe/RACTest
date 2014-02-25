//
//  VMCreditCardViewController.m
//  AgatheChallenge
//
//  Created by Agathe Battestini on 2/24/14.
//  Copyright (c) 2014 Venmo. All rights reserved.
//

#import "VMCreditCardViewController.h"
#import "VMCreditCardViewModel.h"
#import <QuartzCore/QuartzCore.h>

@interface VMCreditCardViewController ()

@end

@implementation VMCreditCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.ccViewModel = [[VMCreditCardViewModel alloc] init];
    }
    return self;
}

- (void)createViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"Enter your Credit Card";
    self.titleLabel.font = [UIFont systemFontOfSize:24.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];

    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.text = @"Message?";
    self.messageLabel.font = [UIFont systemFontOfSize:14.0f];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.messageLabel];

    // credit card number
    self.inputNumberLabel = [[UILabel alloc] init];
    self.inputNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputNumberLabel.text = @"Credit Card Number";
    self.inputNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.inputNumberLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.view addSubview:self.inputNumberLabel];

    self.creditCardNumber = [[UITextField alloc] init];
    self.creditCardNumber.delegate = self;
    self.creditCardNumber.translatesAutoresizingMaskIntoConstraints = NO;
    self.creditCardNumber.placeholder = @"0000 0000 0000 0000";
    self.creditCardNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.creditCardNumber.textAlignment = NSTextAlignmentCenter;
    self.creditCardNumber.borderStyle = UITextBorderStyleRoundedRect;
//    [self setBorderForField:self.creditCardNumber withStatusError:NO];
    [self.view addSubview:self.creditCardNumber];

    UIImage *image = [self.ccViewModel creditCartImage];
    self.creditCardTypeImageView = [[UIImageView alloc] initWithImage:image];
    self.creditCardTypeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.creditCardTypeImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.creditCardTypeImageView];

    // expiration label
    self.inputExpirationLabel = [[UILabel alloc] init];
    self.inputExpirationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputExpirationLabel.text = @"Expiration Date";
    self.inputExpirationLabel.textAlignment = NSTextAlignmentCenter;
    self.inputExpirationLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.view addSubview:self.inputExpirationLabel];

    self.creditCardExpirationDate = [[UITextField alloc] init];
    self.creditCardExpirationDate.delegate = self;
    self.creditCardExpirationDate.translatesAutoresizingMaskIntoConstraints = NO;
    self.creditCardExpirationDate.placeholder = @"MMYYYY";
    self.creditCardExpirationDate.keyboardType = UIKeyboardTypeNumberPad;
    self.creditCardExpirationDate.textAlignment = NSTextAlignmentCenter;
    self.creditCardExpirationDate.borderStyle = UITextBorderStyleRoundedRect;
//    [self setBorderForField:self.creditCardExpirationDate withStatusError:NO];
    [self.view addSubview:self.creditCardExpirationDate];

    // CVV
    self.inputCVVLabel = [[UILabel alloc] init];
    self.inputCVVLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputCVVLabel.text = @"CVV";
    self.inputCVVLabel.textAlignment = NSTextAlignmentCenter;
    self.inputCVVLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.view addSubview:self.inputCVVLabel];

    self.creditCardCVV = [[UITextField alloc] init];
    self.creditCardCVV.translatesAutoresizingMaskIntoConstraints = NO;
    self.creditCardCVV.placeholder = @"0000";
    self.creditCardCVV.delegate = self;
    self.creditCardCVV.keyboardType = UIKeyboardTypeNumberPad;
    self.creditCardCVV.textAlignment = NSTextAlignmentCenter;
    self.creditCardCVV.borderStyle = UITextBorderStyleRoundedRect;
//    [self setBorderForField:self.creditCardCVV withStatusError:NO];

    [self.view addSubview:self.creditCardCVV];

    // button
    self.addCreditCardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addCreditCardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.addCreditCardButton setTitle:@"Add Credit Card" forState:UIControlStateNormal];
    [self.view addSubview:self.addCreditCardButton];

    [self.view sendSubviewToBack:self.creditCardTypeImageView];

    // adding constraints
    NSDictionary *views = @{
            @"title": self.titleLabel,
            @"message": self.messageLabel,
            @"numberLabel": self.inputNumberLabel,
            @"number": self.creditCardNumber,
            @"image": self.creditCardTypeImageView,
            @"expLabel": self.inputExpirationLabel,
            @"expDate": self.creditCardExpirationDate,
            @"cvvLabel": self.inputCVVLabel,
            @"cvv": self.creditCardCVV,
            @"button": self.addCreditCardButton
    };
    NSDictionary *metrics = @{
            @"hPadding" :@(24),
            @"hlPadding" :@(8),
            @"cvvLPadding" :@(24),
            @"cvvPadding" :@(36),
            @"titleTopPadding" :@(38),
            @"titleBottomPadding" :@(38),
            @"bottomPadding" :@(32),
            @"vP" :@(24),
            @"vlP" :@(8),
            @"buttonTopBottom" :@(48),
            @"imW":@(image.size.width),
            @"imH":@(image.size.height),
    };

    NSMutableArray *constraints = [NSMutableArray array];
    NSArray *visualConstraints = @[
            @"|-(hPadding)-[title]-(hPadding)-|",
            @"|-(hPadding)-[message]-(hPadding)-|",
            @"|-(hPadding)-[numberLabel]-(hPadding)-|",
            @"|-(hlPadding)-[image(imW)]-(4)-[number]-(hPadding)-|",
            @"|-(hPadding)-[expLabel]-(cvvLPadding)-[cvvLabel]-(hPadding)-|",
            @"|-(hPadding)-[expDate]-(cvvPadding@800)-[cvv]-(hPadding)-|",
            @"|-(hPadding)-[button]-(hPadding)-|",

            @"V:|-(titleTopPadding)-[title]-(titleBottomPadding)-[message]-(hlPadding)-[numberLabel]-(vlP)-[number]-"
                    "(vP)"
                    "-[expLabel]-(vlP)-[expDate]-"
                    "(>=8)-[button]-(buttonTopBottom)-|",
            @"V:[image(imH)]",

    ];
    [visualConstraints enumerateObjectsUsingBlock:^(NSString* vc, NSUInteger idx, BOOL *stop) {
        [constraints addObjectsFromArray:[NSLayoutConstraint
                constraintsWithVisualFormat:vc
                                    options:0 metrics:metrics views:views]];
    }];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.creditCardTypeImageView attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual toItem:self.creditCardNumber attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0 constant:0.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.inputCVVLabel attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual toItem:self.inputExpirationLabel attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0 constant:0.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.creditCardCVV attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual toItem:self.creditCardExpirationDate attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0 constant:0.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.creditCardCVV attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual toItem:self.inputCVVLabel attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0 constant:0.0]];

    [self.view addConstraints:constraints];

    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
//        view.backgroundColor = [UIColor lightGrayColor];

    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createViews];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector
    (tappedView:)];
    [self.view addGestureRecognizer:gestureRecognizer];

    //bind things

    RAC(self.ccViewModel, ccNumber) = self.creditCardNumber.rac_textSignal;

    @weakify(self);
    RAC(self.ccViewModel, ccCVV) = [self.creditCardCVV.rac_textSignal map:^id(id value) {
        @strongify(self);
        self.creditCardTypeImageView.image = [self.ccViewModel ccvImageWhileEditingCCV:YES];
        return value;
    }];

    RAC(self.ccViewModel, ccExpirationDate) = [self.creditCardExpirationDate.rac_textSignal map:^id(id value) {
        self.creditCardTypeImageView.image = [self.ccViewModel ccvImageWhileEditingCCV:NO];
        return value;
    }];

    self.addCreditCardButton.rac_command = self.ccViewModel.addCCCommand;

    RAC(self.messageLabel, text) = [RACObserve(self.ccViewModel,message) map:^id(id value) {
        return value;
    }];

    RAC(self.creditCardCVV, placeholder) = [RACObserve(self.ccViewModel,ccvPlaceholder) map:^id(id value) {
        return value;
    }];


    // set the image view whenever the credit type of the model changes
    RAC(self.creditCardTypeImageView, image) = [RACObserve(self.ccViewModel, ccType)
            map:^id(id value) {
        @strongify(self);
        if(![self.ccViewModel validCVV:self.creditCardCVV.text]){
            self.creditCardCVV.text = @"";
            self.ccViewModel.ccCVV = @"";
        }
        return [self.ccViewModel creditCartImage];
    }];



}

- (void)tappedView:(UIGestureRecognizer *)recognizer
{
    [self.creditCardCVV resignFirstResponder];
    [self.creditCardExpirationDate resignFirstResponder];
    [self.creditCardNumber resignFirstResponder];
    self.creditCardTypeImageView.image = [self.ccViewModel ccvImageWhileEditingCCV:NO];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField==self.creditCardNumber){
        return [self.ccViewModel validNumber:newString];
    }
    else if (textField==self.creditCardCVV){
        return [self.ccViewModel validCVV:newString];
    }
    else if(textField==self.creditCardExpirationDate){
        return [self.ccViewModel validLengthDate:newString];
    }
    return YES;
}

@end
