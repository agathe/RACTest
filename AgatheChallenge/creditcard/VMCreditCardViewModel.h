//
// Created by Agathe Battestini on 2/24/14.
// Copyright (c) 2014 Venmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVMViewModel.h"

typedef enum VMCreditCardType
{
    VMCreditCardTypeUnknown = 0,
    VMCreditCardTypeAmex,
    VMCreditCardTypeDinersClub,
    VMCreditCardTypeDiscover,
    VMCreditCardTypeJCB,
    VMCreditCardTypeMastercard,
    VMCreditCardTypeVisa,
}VMCreditCardType;


@class VMCreditCardEntity;


@interface VMCreditCardViewModel : RVMViewModel


@property(nonatomic, strong) RACCommand *addCCCommand;

@property (nonatomic, strong) NSString* ccNumber;
@property (nonatomic, strong) NSString *ccCVV;
@property (nonatomic, strong) NSDate *ccExpirationDate;


@property (nonatomic, strong) NSNumber *ccType;


@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSString *ccvPlaceholder;




- (UIImage *)creditCartImage;

- (UIImage *)ccvImageWhileEditingCCV:(BOOL)flag;

- (BOOL)validNumber:(NSString *)text;

- (BOOL)validCVV:(NSString *)cvv;

- (BOOL)validLengthDate:(NSString *)date;

- (BOOL)validDate:(NSString *)date;

- (VMCreditCardType)identifyTypeWithNumber:(NSString *)ccNumber;

@end