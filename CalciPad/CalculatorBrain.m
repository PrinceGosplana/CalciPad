//
//  CalculatorBrain.m
//  mycalulator
//
//  Created by Sojin Kim on 13. 1. 21..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import "CalculatorBrain.h"
#import "CalculatorBrain_Private.h"

@implementation CalculatorBrain 

- (brainState)currentState
{
    return self.state.whoAmI;
}

- (BOOL)moveToNewState:(brainState)newState
{
    if ( (newState == brainState_self) || (newState == self.currentState) ) {
        return NO;
    }
    
    [self.state cleanBeforeLeave];
    switch (newState) {
        case brainState_init:
            self.state = self.initialState;
            break;
        case brainState_left:
            self.state = self.leftOperandState;
            break;
        case brainState_op:
            self.state = self.operatorState;
            break;
        case brainState_right:
            self.state = self.rightOperandState;
            break;
        default:
            NSAssert(NO, @"No such BrainState");
    }
    return YES;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.initialState = [InitialState brainStateOfBrain:self];
        self.operatorState = [GettingOperatorState brainStateOfBrain:self];
        self.leftOperandState = [GettingLeftOperandState brainStateOfBrain:self];
        self.rightOperandState = [GettingRightOperandState brainStateOfBrain:self];
        
        self.state = self.initialState;
        self.inputStringForOperand = @"0";
    }

    return self;
}

- (void)dropCurrentCalculation
{
    self.inputStringForOperand = @"0";
    self.leftOperand = self.rightOperand = 0;
    self.operatorType = invalid;
    self.calculationResult = 0;
    [self moveToNewState:brainState_init];
}

- (void) dropResultLabel {
    self.inputStringForOperand = @"0";
    self.calculationResult = 0;
}
//функция используется при познаковом удалении вводимого значения
- (void)processSingleDigitClean:(BOOL)isLeft{

    if (isLeft) {
        NSString *trimmedString = [self.inputStringForOperand stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableString * deleteOneChapter = [NSMutableString stringWithString: trimmedString];
        if ([deleteOneChapter length]) {
            
            
            // Поиск строки во второй строке
            NSMutableString * returnValue = [NSMutableString stringWithFormat:@"%@", deleteOneChapter];
            if ([returnValue rangeOfString:@"."].location != NSNotFound) {
                int rang = [returnValue rangeOfString:@"." options:NSBackwardsSearch].location;
                int lenth = [returnValue length];
                if (rang == -- lenth) {
                    [self processUnDecimal];
                }
            }
            
            
            [deleteOneChapter deleteCharactersInRange:NSMakeRange([deleteOneChapter length]-1, 1)];
        }
        self.leftOperand = [deleteOneChapter doubleValue];
        self.inputStringForOperand = deleteOneChapter;
    }
    else{

        NSString *trimmedString = [self.inputStringForOperand stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableString * deleteOneChapter = [NSMutableString stringWithString: trimmedString];
        if ([deleteOneChapter length]) {
            NSMutableString * returnValue = [NSMutableString stringWithFormat:@"%@", deleteOneChapter];

            if ([returnValue rangeOfString:@"."].location != NSNotFound) {
                int rang = [returnValue rangeOfString:@"." options:NSBackwardsSearch].location;
                int lenth = [returnValue length];
                if (rang == -- lenth) {
                    [self processUnDecimal];
                }
            }
            
            [deleteOneChapter deleteCharactersInRange:NSMakeRange([deleteOneChapter length]-1, 1)];
        }
        self.rightOperand = [deleteOneChapter doubleValue];
        self.inputStringForOperand = deleteOneChapter;
    }
}

//удаляет последнюю цифру
- (NSString *) deleteLastChapters:(NSNumber *) number {
    NSMutableString * returnValue = [NSMutableString stringWithFormat:@"%@", number];
    if ([returnValue rangeOfString:@"."].location != NSNotFound) {
        int rang = [returnValue rangeOfString:@"." options:NSBackwardsSearch].location;
        rang -= 3;
        while (rang > 0) {
            [returnValue insertString:@" " atIndex:rang];
            rang -= 3;
        }
    } else {
        int rang = [returnValue length];
        while (rang > 0) {
            [returnValue insertString:@" " atIndex:rang];
            rang -= 3;
        }
    }
    return returnValue;
}

- (void)processDigit:(int)digit
{
    while ( [self moveToNewState:[self.state processDigit:digit]] );
}

- (void)processOperator:(int)op
{
    while ( [self moveToNewState:[self.state processOperator:op]] );
}

- (void)processMemoryFunction:(int)func withValue:(double)value;
{
    switch (func) {
        case memAdd:
            self.memoryStore += value;
            break;
        case memSub:
            self.memoryStore -= value;
            break;
        default:
            break;
    }
}

- (void)processMemClear
{
    self.memoryStore = 0;
}

- (void)processMemRecall
{
    while ( [self moveToNewState:[self.state processMemRecall]] );
}

- (void)processMemRecallWithValue:(double)value
{
    self.calculationResult = 0;
    self.memoryStore = value;
}

- (void)processEnter
{
    while ( [self moveToNewState:[self.state processEnter]] );
}

- (void)processSign
{
    while ( [self moveToNewState:[self.state processSign]] );
}

- (void)processDecimal
{
    while ( [self moveToNewState:[self.state processDecimal]] );
}

- (void)processUnDecimal
{
    while ( [self moveToNewState:[self.state processUnDecimal]] );
}

- (void)percentEnter
{
    while ( [self moveToNewState:[self.state processPercent]] );
}
- (double)performOperation
{
    if (add == self.operatorType) {
        self.calculationResult = self.leftOperand + self.rightOperand;
    } else if (sub == self.operatorType) {
        self.calculationResult = self.leftOperand - self.rightOperand;
    } else if (multiply == self.operatorType) {
        self.calculationResult = self.leftOperand * self.rightOperand;
    } else if (divide == self.operatorType) {
        self.calculationResult = self.leftOperand / self.rightOperand;
    } else {NSAssert(NO, @"not supported arithmetic operator"); }
    
    return self.calculationResult;
}

- (double)performPercent
{
    if (add == self.operatorType) {
        self.calculationResult = self.leftOperand + self.leftOperand / 100 * self.rightOperand;
    } else if (sub == self.operatorType) {
        self.calculationResult = self.leftOperand - self.leftOperand / 100 * self.rightOperand;
    } else if (multiply == self.operatorType) {
        self.calculationResult = self.leftOperand * (self.leftOperand / 100 * self.rightOperand);
    } else if (divide == self.operatorType) {
        self.calculationResult = self.leftOperand / (self.leftOperand / 100 * self.rightOperand);
    }
    else {NSAssert(NO, @"not supported arithmetic operator"); }
    
    return self.calculationResult;
}

- (void) setValueData:(double)leftOperand operand:(int)op rightOperand:(double)rightOperand{
    self.leftOperand = leftOperand;
    self.rightOperand = rightOperand;
    self.operatorType = op;
    
    if (0 == op) {
        self.calculationResult = self.leftOperand + self.rightOperand;
    } else if (1 == op) {
        self.calculationResult = self.leftOperand - self.rightOperand;
    } else if (2 == op) {
        self.calculationResult = self.leftOperand * self.rightOperand;
    } else if (3 == op) {
        self.calculationResult = self.leftOperand / self.rightOperand;
    }
    else {NSAssert(NO, @"not supported arithmetic operator"); }
}
- (void)manipulateInputStringForSignChange
{
    NSRange range = {0 , 1};
    
    if ( [self.inputStringForOperand hasPrefix:@"-"] ) {
        self.inputStringForOperand = [self.inputStringForOperand stringByReplacingCharactersInRange:range withString:@""];
    }
    else {
        self.inputStringForOperand = [@"-" stringByAppendingString:self.inputStringForOperand];
    }
}

@end
