//
// Created by Agathe Battestini on 2/24/14.
// Copyright (c) 2014 Venmo. All rights reserved.
//

#import "VMCreditCardViewModel.h"
#import "Luhn.h"

@interface VMCreditCardViewModel()

// top signal
@property(nonatomic, strong) RACSignal *ccValidSignal;

// individual validation signals
@property(nonatomic, strong) RACSignal *ccNumberValidSignal;
@property(nonatomic, strong) RACSignal *ccDateValidSignal;
@property(nonatomic, strong) RACSignal *ccCVVValidSignal;

@end


@implementation VMCreditCardViewModel {

    NSDictionary *maxNumberLength;
    NSDictionary *maxCVVLength;
}

RACSequence *RACSequenceWithRange(NSRange range) {
    if (!range.length)
        return [RACSequence empty];

    return [RACSequence sequenceWithHeadBlock:^id{
        return @(range.location);
    } tailBlock:^RACSequence *{
        return RACSequenceWithRange(NSMakeRange(range.location+1, range.length-1));
    }];
}


- (id)init {
    self = [super init];
    if (!self) return nil;


    maxNumberLength = @{
            @(VMCreditCardTypeAmex): @15,
            @(VMCreditCardTypeVisa): @16,
            @(VMCreditCardTypeDinersClub): @16,
            @(VMCreditCardTypeMastercard): @16,
            @(VMCreditCardTypeJCB): @16,
            @(VMCreditCardTypeDiscover): @16,
    };
    maxCVVLength = @{
            @(VMCreditCardTypeAmex): @4,
            @(VMCreditCardTypeVisa): @3,
            @(VMCreditCardTypeDinersClub): @3,
            @(VMCreditCardTypeMastercard): @3,
            @(VMCreditCardTypeJCB): @3,
            @(VMCreditCardTypeDiscover): @3,
            @(VMCreditCardTypeUnknown): @3,
    };

    return self;
}


- (UIImage *)creditCartImage
{
    switch (self.ccType.integerValue){
        case VMCreditCardTypeAmex:
            return [UIImage imageNamed:@"VDKAmex"];
        case VMCreditCardTypeDinersClub:
            return [UIImage imageNamed:@"VDKDinersClub"];
        case VMCreditCardTypeDiscover:
            return [UIImage imageNamed:@"VDKDiscover"];
        case VMCreditCardTypeJCB:
            return [UIImage imageNamed:@"VDKJCB"];
        case VMCreditCardTypeMastercard:
            return [UIImage imageNamed:@"VDKMastercard"];
        case VMCreditCardTypeVisa:
            return [UIImage imageNamed:@"VDKVisa"];
        default:
            return [UIImage imageNamed:@"VDKCreditCard"];
    }
}

- (UIImage *)ccvImageWhileEditingCCV:(BOOL)flag
{
    if(flag){
        if([self.ccType integerValue] == VMCreditCardTypeAmex)
            return [UIImage imageNamed:@"VDKAmexCVV"];
        else
            return [UIImage imageNamed:@"VDKCVV"];
    }
    else
        return [self creditCartImage];
}


- (RACCommand *)addCCCommand {
    if (!_addCCCommand) {
        // would get the credit card object
        _addCCCommand = [[RACCommand alloc] initWithEnabled:self.ccValidSignal signalBlock:^RACSignal *(id input) {
            NSLog(@"Adding the credit card");
            if(![Luhn validateString:self.ccNumber])
                self.message = @"ERROR: Check the number";
            else
                self.message = @"Success";
            return [RACSignal empty];
        }];
    }
    return _addCCCommand;
}

- (RACSignal *)ccValidSignal {
    if (!_ccValidSignal) {
        _ccValidSignal = [RACSignal
                combineLatest:@[self.ccNumberValidSignal ,self.ccCVVValidSignal,  self.ccDateValidSignal]
                       reduce:^(id validNumber, id validCVV, id validDate) {
            return @([validNumber boolValue] && [validCVV boolValue] && [validDate boolValue]);
        }];
    }
    return _ccValidSignal;
}

- (RACSignal *)ccNumberValidSignal {
    @weakify(self);
    if (!_ccNumberValidSignal) {
        _ccNumberValidSignal = [RACObserve(self, ccNumber) map:^id(NSString *number) {
            @strongify(self);
            // if type was not yet identify:
            VMCreditCardType type = [self identifyTypeWithNumber:self.ccNumber];
            self.ccType = @(type);
            if([self.ccType integerValue] == VMCreditCardTypeAmex)
                self.ccvPlaceholder = @"0000";
            else
                self.ccvPlaceholder = @"000";

            // if type was identify, check that it's under the limit
            return @([self exactNumberLength:self.ccNumber]);
        }];
    }
    return _ccNumberValidSignal;
}

- (RACSignal *)ccCVVValidSignal {

    @weakify(self);
    if (!_ccCVVValidSignal) {
        _ccCVVValidSignal = [RACObserve(self, ccCVV) map:^id(NSString *number) {
            @strongify(self);
            // we check that the CVV is of the right length for the type of card
            BOOL valid = [self validCVV:self.ccCVV];
            return valid && [self exactLengthCVV:self.ccCVV]? @YES : @NO;
        }];
    }
    return _ccCVVValidSignal;
}

- (RACSignal *)ccDateValidSignal {

    @weakify(self);
    if (!_ccDateValidSignal) {
        _ccDateValidSignal = [RACObserve(self, ccExpirationDate) map:^id(NSString *number) {
            @strongify(self);
            // we check that the CVV is of the right length for the type of card
            BOOL valid = [self validDate:number];
            return valid && [self exactLengthDate:number]? @YES : @NO;
        }];
    }
    return _ccDateValidSignal;
}


/**
* Returns YES if the new value for the credit number string is still valid
*/
- (BOOL)validNumber:(NSString *)text {
    VMCreditCardType typeWithNewText = [self identifyTypeWithNumber:text];
    if(typeWithNewText > VMCreditCardTypeUnknown){
        // check length
        return text.length <= [maxNumberLength[@(typeWithNewText)] integerValue];
    }
    // if the length is >=6 and we have no type, user cannot type
    return (text.length <= 6);
}

- (BOOL)exactNumberLength:(NSString *)text {
    VMCreditCardType typeWithNewText = [self identifyTypeWithNumber:text];
    return (typeWithNewText > VMCreditCardTypeUnknown) && text.length == [maxNumberLength[@(typeWithNewText)] integerValue];
}


- (BOOL)validCVV:(NSString *)cvv
{
    return cvv.length <= [maxCVVLength[self.ccType] integerValue];
}

- (BOOL)exactLengthCVV:(NSString *)cvv
{
    return cvv.length == [maxCVVLength[self.ccType] integerValue];
}


- (BOOL)validLengthDate:(NSString *)date
{
    return [self validDate:date] && date.length <= 6;
}

- (BOOL)exactLengthDate:(NSString *)date
{
    return date.length==6;
}

- (BOOL)validDate:(NSString*)date
{
    if(date.length==0) return YES;

    RACSequence *mmSeq = [RACSequenceWithRange(NSMakeRange(1, 12)) map:^id(NSNumber *nb) {
        return [NSString stringWithFormat:@"%02d", nb.integerValue];
    }];
    RACSequence *yyyySeq = [RACSequenceWithRange(NSMakeRange(2014, 20)) map:^id(NSNumber *nb) {
        return [NSString stringWithFormat:@"%d", nb.integerValue];
    }];

    NSString *mmString = [date substringWithRange:NSMakeRange(0, MIN(date.length, 2))];
    NSString *yyyyString = date.length > 2 ?  [date substringWithRange:NSMakeRange(MIN(2, date.length),
            MIN(date.length - 2,  4))] : @"";


    RACSequence *mmResult = [mmSeq filter:^BOOL(NSString *mm) {
        if(mm.length >= mmString.length){
            mm = [mm substringWithRange:NSMakeRange(0, MIN(mm.length, mmString.length))];
            return [mm isEqualToString:mmString];
        }
        return NO;
    }] ;
    if(yyyyString.length==0){
        NSArray *res = [mmResult array];
        return res.count > 0;
    }

    RACSequence *yyyyResult = [yyyySeq filter:^BOOL(NSString *yyyy) {
        if(yyyy.length >= yyyyString.length){
            yyyy = [yyyy substringWithRange:NSMakeRange(0, MIN(yyyy.length, yyyyString.length))];
            return [yyyy isEqualToString:yyyyString];
        }
        return NO;
    }] ;
    NSArray *res1 = [mmResult array];
    NSArray *res2 = [yyyyResult array];

    return res1.count > 0 && res2.count > 0 ;

}



/**
* Returns the type of card based on the number. No side effect.
*/
- (VMCreditCardType)identifyTypeWithNumber:(NSString*)ccNumber
{
    // create JCB strings
    RACSequence *jcbStrings = [RACSequenceWithRange(NSMakeRange(3528, 3589-3528 + 1)) map:^id(NSNumber *nb) {
        return [nb description];
    }];
    // create the discover strings
    RACSequence *discoRange = [
            [RACSequenceWithRange(NSMakeRange(622126, 622925 - 622126 + 1))
            concat:RACSequenceWithRange(NSMakeRange(644, 649 - 644 + 1))]
            concat:@[@"6011", @"65"].rac_sequence ];
    RACSequence *discoStrings = [discoRange map:^id(NSNumber *nb) {
        return [nb description];
    }];
    // create the Mastercard
    RACSequence *masterStrings = [RACSequenceWithRange(NSMakeRange(50, 55-54 + 1)) map:^id(NSNumber *nb) {
        return [nb description];
    }];

    NSDictionary *all = @{
            @(VMCreditCardTypeAmex): @[@"34", @"37"],
            @(VMCreditCardTypeVisa): @[@"4"],
            @(VMCreditCardTypeDinersClub): @[@"54", @"55"],
            @(VMCreditCardTypeMastercard): [masterStrings array], // dont know what to do for the 54/55 case
            @(VMCreditCardTypeJCB): [jcbStrings array],
            @(VMCreditCardTypeDiscover): [discoStrings array],
    };

    // Does the identification of the type based on the number:
    // for each type of card, keeps the tuple only if one of the prefixes matches (filter)
    // then returns the type of card that was matched (if any, in the map)
    RACSequence *result = [[all.rac_sequence
    filter:^BOOL(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *type, NSArray*prefixes) = tuple;
        BOOL passes = [prefixes.rac_sequence any:^BOOL(NSString* prefix) {
            return [ccNumber hasPrefix:prefix];
        }];
        return passes;
    }]
    map:^(RACTuple *tuple){
        RACTupleUnpack(NSNumber *type, NSArray*prefixes) = tuple;
        return type;
    }];

    // if we got a match based on the prefix, we return that
    NSArray * matching = [result array];
    if (matching.count > 0){
        VMCreditCardType type = (VMCreditCardType) [matching.firstObject integerValue];
        if(type > VMCreditCardTypeUnknown){
            return type;
        }
    }
    return VMCreditCardTypeUnknown;
}



@end