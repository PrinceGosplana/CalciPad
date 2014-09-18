//
//  CalculatorBrain.h
//  mycalulator
//
//  Created by Sojin Kim on 13. 1. 21..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrainState.h"
#import "OperatorUtil.h"

@interface CalculatorBrain : NSObject

@property (nonatomic, strong, readonly) NSString *inputStringForOperand;
@property (nonatomic, readonly) double leftOperand;
@property (nonatomic, readonly) basicArithmeticOperator operatorType;
@property (nonatomic, readonly) double rightOperand;
@property (nonatomic, readonly) double calculationResult;
@property (nonatomic, readonly) double memoryStore;
@property (nonatomic) BOOL toDisplay;

- (id)init;
- (void)dropCurrentCalculation;

- (void)processDigit:(int)digit;
- (void)processOperator:(int)op;
- (void)processMemoryFunction:(int)func withValue:(double)value;
- (void)processMemClear;
- (void)processSingleDigitClean:(BOOL)isLeft;
- (void)processMemRecall;
- (void)processMemRecallWithValue:(double)value;
- (void)processEnter;
- (void)processSign;
- (void)processDecimal;
- (void)processUnDecimal;
- (void)percentEnter;
- (void) setValueData:(double)leftOperand operand:(int)op rightOperand:(double)rightOperand;
- (brainState)currentState;
- (void) dropResultLabel;

@end
