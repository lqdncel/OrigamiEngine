//
//  ConverterUnitTests.m
//  OrigamiEngine
//
//  Created by ap4y on 8/14/12.
//
//

#import "ConverterUnitTests.h"

#import "ORGMConverter.h"
#import "ORGMInputUnit.h"
#import "ORGMOutputUnit.h"

@interface ConverterUnitTests ()
@property (retain, nonatomic) ORGMConverter* converter;
@end

@implementation ConverterUnitTests

- (void)setUp {
    [super setUp];
    ORGMInputUnit* input = [[ORGMInputUnit alloc] init];
    NSURL* flacUrl = [[NSBundle bundleForClass:self.class] URLForResource:@"multiple-vc"
                                                            withExtension:@"flac"];
    [input openWithUrl:flacUrl];
    _converter = [[ORGMConverter alloc] initWithInputUnit:input];
    
    ORGMOutputUnit* output = [[ORGMOutputUnit alloc] initWithConverter:_converter];
    STAssertTrue([_converter setupWithOutputUnit:output], nil);        
    
    [input release];
    [output release];
}

- (void)tearDown {
    [_converter release];
    [super tearDown];
}

- (void)testConverterUnitShouldHaveValidInputUnit {
    STAssertNotNil(_converter.inputUnit, nil);
}

- (void)testConverterUnitShouldHaveValidOutputUnit {
    STAssertNotNil(_converter.outputUnit, nil);
}

- (void)testConverterUnitShouldProcessData {
    [_converter.inputUnit process];
    [_converter process];
    STAssertEquals(131072U, _converter.convertedData.length, nil);
}

- (void)testInputUnitShouldNotExceedMaxAmountInBuffer {
    [_converter.inputUnit process];
    [_converter process];
    NSUInteger _saveLength = _converter.convertedData.length;
    [_converter.inputUnit process];
    [_converter process];
    STAssertEquals(_saveLength, _converter.convertedData.length, nil);
}

- (void)testConverterUnitshouldReinitWithNewInputUnit {
    [_converter.inputUnit process];
    [_converter process];
    NSUInteger _saveLength = _converter.convertedData.length;
    
    ORGMInputUnit* input = [[ORGMInputUnit alloc] init];
    NSURL* flacUrl = [[NSBundle bundleForClass:self.class] URLForResource:@"multiple-vc"
                                                            withExtension:@"flac"];
    [input openWithUrl:flacUrl];
    [_converter reinitWithNewInput:input withDataFlush:NO];
    
    STAssertEquals(input, _converter.inputUnit, nil);
    STAssertEquals(_saveLength, _converter.convertedData.length, nil);
    [input release];
}

- (void)testConverterUnitshouldReinitWithNewInputUnitAndFlushData {
    [_converter.inputUnit process];
    [_converter process];
    
    ORGMInputUnit* input = [[ORGMInputUnit alloc] init];
    NSURL* flacUrl = [[NSBundle bundleForClass:self.class] URLForResource:@"multiple-vc"
                                                            withExtension:@"flac"];
    [input openWithUrl:flacUrl];
    [_converter reinitWithNewInput:input withDataFlush:YES];
    
    STAssertEquals(input, _converter.inputUnit, nil);
    STAssertEquals(0U, _converter.convertedData.length, nil);
    [input release];
}

@end
