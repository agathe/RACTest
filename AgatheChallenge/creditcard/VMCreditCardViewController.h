//
//  VMCreditCardViewController.h
//  AgatheChallenge
//
//  Created by Agathe Battestini on 2/24/14.
//  Copyright (c) 2014 Venmo. All rights reserved.
//



@class VMCreditCardViewModel;

@interface VMCreditCardViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UILabel *inputNumberLabel;
@property (nonatomic, strong) UITextField *creditCardNumber;
@property (nonatomic, strong) UIImageView *creditCardTypeImageView;

@property (nonatomic, strong) UILabel *inputExpirationLabel;
@property (nonatomic, strong) UITextField *creditCardExpirationDate;

@property (nonatomic, strong) UILabel *inputCVVLabel;
@property (nonatomic, strong) UITextField *creditCardCVV;

@property (nonatomic, strong) UIButton *addCreditCardButton;

@property (nonatomic, strong) VMCreditCardViewModel *ccViewModel;

@end
