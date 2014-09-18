#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "CalculatorBrain.h"
#import "OperatorUtil.h"
#import "RFRateMe.h"

#define kNumberOfDaysUntilShowAgain 14

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel * resultLabel;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) IBOutlet UILabel * equationLabel;
@property (nonatomic, strong) IBOutlet UILabel * memoryLabel;
@property (nonatomic, strong) UIImageView * memoryUseLabel;
@end


@implementation ViewController{
    UITableView * myTableView;
    NSMutableArray * arrayResults;
//    int rowsCount;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //top view
    CGRect topViewRect = CGRectMake(0, 0, 768, 314);
    topView = [[UIImageView alloc]initWithFrame:topViewRect];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:topView];


    CGRect rectTableView = CGRectMake(0, 0, 753, 100);
    myTableView = [[UITableView alloc] initWithFrame:rectTableView style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight = 100;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 98, 740, 4)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];

    self.equationLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 115, 700, 40)];
    [self.equationLabel setTextAlignment:NSTextAlignmentRight];
    [self.equationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:50]];
    [self.equationLabel setTextColor:[UIColor blackColor]];
    [self.equationLabel setBackgroundColor:[UIColor clearColor]];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.equationLabel.text = @"0";
    [self.view addSubview:self.equationLabel];

    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 720, 100)];
    [self.resultLabel setTextAlignment:NSTextAlignmentRight];
    [self.resultLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:110]];
    [self.resultLabel setTextColor:[UIColor blackColor]];
    [self.resultLabel setBackgroundColor:[UIColor clearColor]];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.resultLabel.text = @"0";
    [self.view addSubview:self.resultLabel];
    
    self.memoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.memoryLabel.text = @"M";
    self.memoryLabel.textColor = [UIColor blackColor];
    self.memoryUseLabel = [[UIImageView alloc] initWithFrame:CGRectMake(20, 75, 20, 50)];
    self.memoryUseLabel.alpha = 0.0f;
    [self.memoryUseLabel addSubview:self.memoryLabel];
    [self.view addSubview:self.memoryUseLabel];
    
    menu = [UIMenuController sharedMenuController];

    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resultLabelTap:)];
    [self.resultLabel setUserInteractionEnabled:YES];
    [self.resultLabel addGestureRecognizer:gesture];
    
    UIButton * buttonAC = [self createButton:@selector(clearPressed:) tag:0 posX:109 posY:324 imgNormalState:@"ac-brown.png" imgLightState:@"tap-ac-brown.png"];
    [self.view addSubview:buttonAC];
    
    UIButton * buttonC = [self createButton:@selector(clearSingleDigitInResult:) tag:0 posX:259 posY:324 imgNormalState:@"c-brown.png" imgLightState:@"tap-с-brown.png"];
    [self.view addSubview:buttonC];
    
    UIButton * buttonPlusMinus = [self createButton:@selector(signPressed:) tag:0 posX:409 posY:324 imgNormalState:@"+--brown.png" imgLightState:@"tap-+--brown.png"];
    [self.view addSubview:buttonPlusMinus];
    
    UIButton * buttonPercent = [self createButton:@selector(percentPressed:) tag:0 posX:559 posY:324 imgNormalState:@"%-brown.png" imgLightState:@"tap-%-brown.png"];
    [self.view addSubview:buttonPercent];
    
    
    
    UIButton * buttonMR = [self createButton:@selector(memRecallPressed:) tag:0 posX:109 posY:434 imgNormalState:@"m-green.png" imgLightState:@"tap-m-green.png"];
    [self.view addSubview:buttonMR];
    
    UIButton * buttonMC = [self createButton:@selector(memClearPressed:) tag:3 posX:259 posY:434 imgNormalState:@"mc-green.png" imgLightState:@"tap-mc-green.png"];
    [self.view addSubview:buttonMC];
    
    UIButton * buttonMM = [self createButton:@selector(memoryFunctionPressed:) tag:1 posX:409 posY:434 imgNormalState:@"m--green.png" imgLightState:@"tap-m--green.png"];
    [self.view addSubview:buttonMM];
    
    UIButton * buttonMP = [self createButton:@selector(memoryFunctionPressed:) tag:2 posX:559 posY:434 imgNormalState:@"m+-green.png" imgLightState:@"tap-m+-green.png"];
    [self.view addSubview:buttonMP];
    

    
    UIButton * button7 = [self createButton:@selector(digitPressed:) tag:7 posX:109 posY:554 imgNormalState:@"7-grey.png" imgLightState:@"tap-7-grey.png"];
    [self.view addSubview:button7];
    
    UIButton * button8 = [self createButton:@selector(digitPressed:) tag:8 posX:259 posY:554 imgNormalState:@"8-grey.png" imgLightState:@"tap-8-grey.png"];
    [self.view addSubview:button8];
    
    UIButton * button9 = [self createButton:@selector(digitPressed:) tag:9 posX:409 posY:554 imgNormalState:@"9-grey.png" imgLightState:@"tap-9-grey.png"];
    [self.view addSubview:button9];
    
    UIButton * buttonDivide = [self createButton:@selector(operatorPressed:) tag:3 posX:559 posY:554 imgNormalState:@":-brown.png" imgLightState:@"tap-:-brown.png"];
    [self.view addSubview:buttonDivide];


    
    UIButton * button4 = [self createButton:@selector(digitPressed:) tag:4 posX:109 posY:674 imgNormalState:@"4-grey.png" imgLightState:@"tap-4-grey.png"];
    [self.view addSubview:button4];
    
    UIButton * button5 = [self createButton:@selector(digitPressed:) tag:5 posX:259 posY:674 imgNormalState:@"5-grey.png" imgLightState:@"tap-5-grey.png"];
    [self.view addSubview:button5];
    
    UIButton * button6 = [self createButton:@selector(digitPressed:) tag:6 posX:409 posY:674 imgNormalState:@"6-grey.png" imgLightState:@"tap-6-grey.png"];
    [self.view addSubview:button6];
    
    UIButton * buttonMultipli = [self createButton:@selector(operatorPressed:) tag:2 posX:559 posY:674 imgNormalState:@"x-brown.png" imgLightState:@"tap-x-brown.png"];
    [self.view addSubview:buttonMultipli];

    
    
    
    UIButton * button1 = [self createButton:@selector(digitPressed:) tag:1 posX:109 posY:794 imgNormalState:@"1-grey.png" imgLightState:@"tap-1-grey.png"];
    [self.view addSubview:button1];
    
    UIButton * button2 = [self createButton:@selector(digitPressed:) tag:2 posX:259 posY:794 imgNormalState:@"2-grey.png" imgLightState:@"tap-2-grey.png"];
    [self.view addSubview:button2];
    
    UIButton * button3 = [self createButton:@selector(digitPressed:) tag:3 posX:409 posY:794 imgNormalState:@"3-grey.png" imgLightState:@"tap-3-grey.png"];
    [self.view addSubview:button3];
    
    UIButton * buttonMinus = [self createButton:@selector(operatorPressed:) tag:1 posX:559 posY:794 imgNormalState:@"--brown.png" imgLightState:@"tap---brown.png"];
    [self.view addSubview:buttonMinus];

    
    
    
    UIButton * button0 = [self createButton:@selector(digitPressed:) tag:0 posX:109 posY:914 imgNormalState:@"0-grey.png" imgLightState:@"tap-0-grey.png"];
    [self.view addSubview:button0];
    
    UIButton * buttonDot = [self createButton:@selector(decimalPressed:) tag:0 posX:259 posY:914 imgNormalState:@"dot-grey.png" imgLightState:@"tap-dot-grey.png"];
    [self.view addSubview:buttonDot];
    
    UIButton * buttonEqual = [self createButton:@selector(enterPressed:) tag:0 posX:409 posY:914 imgNormalState:@"yellow.png" imgLightState:@"tap-yellow.png"];
    [self.view addSubview:buttonEqual];
    
    UIButton * buttonPlus = [self createButton:@selector(operatorPressed:) tag:0 posX:559 posY:914 imgNormalState:@"+-brown.png" imgLightState:@"tap-+-brown.png"];
    [self.view addSubview:buttonPlus];

    //Определяю первую дату запуска программы
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstStart"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    

    if (!rateCompleted ) {
        NSLog(@"First start");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstStart"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //сохраняю день первого запуска программы
        NSDate *now = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:now] forKey:@"FirstStartDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        //получаю день первого запуска программы и текущий день
        NSString *start = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstStartDate"];
        NSString *end = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDate *startDate = [dateFormatter dateFromString:start];
        NSDate *endDate = [dateFormatter dateFromString:end];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        NSLog(@"day before first start %ld", (long)[components day]);
        
        //если более 14 дней разницы (kNumberOfDaysUntilShowAgain), то прошу нас лайкнуть
        
        if ((long)[components day] >= kNumberOfDaysUntilShowAgain){
            [RFRateMe showRateAlert];
        }
    }
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayResults count];
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    
    // Similar to UITableViewCell, but
    CustomTableViewCell *cell = (CustomTableViewCell *)[myTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Just want to test, so I hardcode the data
    cell.textLabel.text = [arrayResults objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//метод при выборе секции возвращает в верхнюю строку выражение, в нижнюю результат
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.equationLabel.text = selectedCell.textLabel.text;
    
    //создаю изменяемую строку
    NSMutableString * returnValue = [NSMutableString stringWithFormat:@"%@", selectedCell.textLabel.text];
    
    //удалюя из нее все пробелы
    [returnValue replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[returnValue length]}];
    NSLog(@"return value %@", returnValue);
    if ([returnValue rangeOfString:@"+"].location != NSNotFound) {
        //получаю номер позиции знака
        int rang = [returnValue rangeOfString:@"+" options:NSBackwardsSearch].location;
        NSString * leftOperand = [returnValue substringToIndex:rang];
        NSString * rightOperand = [returnValue substringFromIndex:rang+1];
        [self.brain setValueData:[leftOperand doubleValue] operand:0 rightOperand:[rightOperand doubleValue]];
    }
    if ([returnValue rangeOfString:@"-"].location != NSNotFound) {
        int rang = [returnValue rangeOfString:@"-" options:NSBackwardsSearch].location;
        NSString * leftOperand = [returnValue substringToIndex:rang];
        NSString * rightOperand = [returnValue substringFromIndex:rang+1];
        [self.brain setValueData:[leftOperand doubleValue] operand:1 rightOperand:[rightOperand doubleValue]];
    }
    if ([returnValue rangeOfString:@"÷"].location != NSNotFound) {
        int rang = [returnValue rangeOfString:@"÷" options:NSBackwardsSearch].location;
        NSString * leftOperand = [returnValue substringToIndex:rang];
        NSString * rightOperand = [returnValue substringFromIndex:rang+1];
        [self.brain setValueData:[leftOperand doubleValue] operand:3 rightOperand:[rightOperand doubleValue]];
    }
    if ([returnValue rangeOfString:@"x"].location != NSNotFound) {
        int rang = [returnValue rangeOfString:@"x" options:NSBackwardsSearch].location;
        NSString * leftOperand = [returnValue substringToIndex:rang];
        NSString * rightOperand = [returnValue substringFromIndex:rang+1];
        [self.brain setValueData:[leftOperand doubleValue] operand:2 rightOperand:[rightOperand doubleValue]];
    }
    [self updateDisplay];
}

//метод создает меню для копирования и добавляет его к результирующей (нижней) метке
- (void)resultLabelTap:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.resultLabel];
    UIMenuItem * item1 = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyResultLabel)];
    [menu setMenuItems:[NSArray arrayWithObjects:item1, nil]];
    [menu setTargetRect:CGRectMake(point.x, point.y, 1, 1) inView:self.resultLabel];
    [menu setMenuVisible:YES animated:YES];
}
//метод копирует число в результирующей (нижней) строке в память устройства
- (void)copyResultLabel{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.brain.inputStringForOperand;
}

#pragma mark - Create button

- (UIButton *)createButton:(SEL)selector  tag:(int)tagB posX:(float)pX posY:(float)pY imgNormalState:(NSString *)iNS imgLightState:(NSString *)iLS{
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(pX, pY, 100, 100);
    button.tag = tagB;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:iNS] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:iLS] forState:UIControlStateHighlighted];
    
    return button;
}

#pragma mark - Brain calculator

- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

#pragma mark - Button pressed

- (IBAction)digitPressed:(UIButton *)sender
{
    NSLog(@"self %f", [self.brain.inputStringForOperand doubleValue]);
    if ([self.brain.inputStringForOperand doubleValue] < 100000000000000) {
        [self.brain processDigit:[sender tag]];
        [self updateDisplay];
    }
}

- (IBAction)decimalPressed:(UIButton *)sender
{
    [self.brain processDecimal];
    [self updateDisplay];
}

- (IBAction)signPressed:(UIButton *)sender
{
    [self.brain processSign];
    [self updateDisplay];
}

- (IBAction)clearPressed:(UIButton *)sender
{
    [self.brain dropCurrentCalculation];
    [self updateDisplay];
}

// познаковое удаление цифр с экрана
- (IBAction)clearSingleDigitInResult:(UIButton *)sender{
    if (self.brain.leftOperand && self.brain.rightOperand) {
        [self.brain processSingleDigitClean:NO];
        [self updateDisplayAfterC:NO];
    }
    else{
        [self.brain processSingleDigitClean:YES];
        [self updateDisplayAfterC:YES];
    }
}

- (IBAction)enterPressed:(UIButton *)sender
{
    [self.brain processEnter];
    //добавляем результирующую строку в массив
    [arrayResults addObject:self.equationLabel.text ];
    [myTableView reloadData];
    
    //проверяю есть ли в массиве объекты, если не проверять - краш
    if ([arrayResults count]) {
        //программно отображаем последнюю строку в таблице
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow: [arrayResults count]-1 inSection: 0];
        [myTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
        [self updateDisplay];
}

- (IBAction)memRecallPressed:(UIButton *)sender {
    [self.brain processMemRecall];
    [self updateDisplay];
}

- (IBAction)memClearPressed:(UIButton *)sender {
    [self.brain processMemClear];
    [UIView animateKeyframesWithDuration:0.3f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.memoryUseLabel.alpha = 0.0f;
    }completion:^(BOOL finished){
        isMemoryVisible = NO;
    }];
    [self updateDisplay];
}


- (IBAction)memoryFunctionPressed:(UIButton *)sender {
    
    // удаляю все пробелы, т.к. значения приходят с пробелами и при переводе в double вводятся числа до пробела
    NSMutableString * delWhiteSpace = [[NSMutableString alloc] initWithString: self.resultLabel.text];
    [delWhiteSpace replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0, [delWhiteSpace length]}];
    
    [self.brain processMemoryFunction:[sender tag] withValue:[delWhiteSpace doubleValue]];
    [self.brain dropResultLabel];
    [self updateDisplay];
    if (!isMemoryVisible) {
        [UIView animateKeyframesWithDuration:0.3f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            self.memoryUseLabel.alpha = 1.0f;
        }completion:^(BOOL finished){
            isMemoryVisible = YES;
        }];
    }
    else
    {
         [UIView animateKeyframesWithDuration:0.5f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            self.memoryUseLabel.alpha = 0.0f;
        }completion:^(BOOL finished){
            [self finishAnim];
        }];

    }
           
    [self updateDisplay];
}

- (void) finishAnim {
        [UIView animateKeyframesWithDuration:0.5f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            self.memoryUseLabel.alpha = 1.0f;
        }completion:^(BOOL finished){
            self.memoryUseLabel.alpha = 1.0f;
        }];
}

- (IBAction)operatorPressed:(UIButton *)sender
{
    [self.brain processOperator:[sender tag]];
    BOOL check = [[arrayResults lastObject] isEqualToString: self.equationLabel.text];
    if (self.brain.toDisplay && !check) {
        [arrayResults addObject:self.equationLabel.text ];
        [myTableView reloadData];
        if ([arrayResults count]) {
            //программно отображаем последнюю строку в таблице
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: [arrayResults count]-1 inSection: 0];
            [myTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        self.brain.toDisplay = NO;
    }
    [self updateDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)percentPressed:(UIButton *)sender{
    [self.brain percentEnter];
    [self updateDisplay];
}

#pragma mark - Update display

//update display after use memory

- (void)updateDisplayAfterC:(BOOL)isLeft{
    if (isLeft) {
        self.resultLabel.text = [self returnSeparateNSStrings:self.brain.inputStringForOperand];
        self.equationLabel.text =  self.brain.inputStringForOperand;
    }
    else{
        self.resultLabel.text = [self returnSeparateNSStrings:self.brain.inputStringForOperand];
        self.equationLabel.text = [NSString stringWithFormat:@"%g %@ %@", self.brain.leftOperand, [OperatorUtil stringValue:self.brain.operatorType], self.brain.inputStringForOperand];
        if (!arrayResults) {
            arrayResults = [[NSMutableArray alloc] init];
        }
    }
}

//base update display

- (void)updateDisplay{
    NSNumber * calcResult = [NSNumber numberWithDouble:self.brain.calculationResult];
    //при выборе левого операнда он выводится на верхний дисплей
    if (brainState_left== self.brain.currentState ) {
        self.resultLabel.text = [self returnSeparateNSStrings:self.brain.inputStringForOperand];
        self.equationLabel.text = self.brain.inputStringForOperand;
    }
    else
    {
        self.resultLabel.text = [self returnSeparateNSStrings:self.brain.inputStringForOperand];
        self.equationLabel.text = self.brain.inputStringForOperand;
    }
    
    // display equation
    if (brainState_op == self.brain.currentState &&   self.brain.leftOperand) {
        self.equationLabel.text = [NSString stringWithFormat:@"%g %@", self.brain.leftOperand, [OperatorUtil stringValue:self.brain.operatorType]];
    }
    else if(self.brain.rightOperand){
        if (self.brain.calculationResult)
            self.resultLabel.text = [self returnSeparateNSString:calcResult];
        else
            self.resultLabel.text = [self returnSeparateNSStrings:self.brain.inputStringForOperand];//[self returnSeparateNSString:right];
        
            self.equationLabel.text = [NSString stringWithFormat:@"%g %@ %g", self.brain.leftOperand, [OperatorUtil stringValue:self.brain.operatorType], self.brain.rightOperand];


        if (!arrayResults) {
            arrayResults = [[NSMutableArray alloc] init];
        }
    }
    if (self.brain.calculationResult >= 99999999999999) {
        self.resultLabel.text = @"Error";
    }
}
#pragma mark - Add white space to result string

//вставляет отступ в строку до точки через каждые три знака
- (NSString *)returnSeparateNSString: (NSNumber *)sep{
    NSMutableString * returnValue = [NSMutableString stringWithFormat:@"%@", sep];
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

//вставляет отступ в строку до точки через каждые три знака
- (NSString *)returnSeparateNSStrings: (NSString *)sep{
    NSMutableString * returnValue = [NSMutableString stringWithString:sep];
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

@end
