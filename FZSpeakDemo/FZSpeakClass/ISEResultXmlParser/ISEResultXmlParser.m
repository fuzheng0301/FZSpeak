//
//  ISEResultXmlParser.m
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import "ISEResultXmlParser.h"
#import "ISEResult.h"
#import "ISEResultPhone.h"
#import "ISEResultSyll.h"
#import "ISEResultWord.h"
#import "ISEResultSentence.h"
#import "ISEResultFinal.h"
#import "ISEResultReadSyllable.h"
#import "ISEResultReadWord.h"
#import "ISEResultReadSentence.h"

@interface ISEResultXmlParser ()

@property(nonatomic,retain)ISEResult* xmlResult;

@property(nonatomic,assign)BOOL isPlainResult;
@property(nonatomic,assign)BOOL isRecPaperPassed;
@property(nonatomic,retain)ISEResultPhone* phone;
@property(nonatomic,retain)ISEResultSyll*  syll;
@property(nonatomic,retain)ISEResultWord*  word;
@property(nonatomic,retain)ISEResultSentence* sentence;

@end

@implementation ISEResultXmlParser

void readTotalResult(ISEResult* result, NSDictionary* attrDic);
ISEResultPhone* createPhone(NSDictionary* attrDic);
ISEResultSyll* createSyll(NSDictionary* attrDic);
ISEResultWord* createWord(NSDictionary* attrDic);
ISEResultSentence* createSentence(NSDictionary* attrDic);

- (void)clearAllProperty{
    self.isPlainResult=NO;
    self.isRecPaperPassed=NO;
    self.phone=nil;
    self.syll=nil;
    self.word=nil;
    self.sentence=nil;
    
}

- (void)parserXml:(NSString*) xml{
    
    [self clearAllProperty];
    if(xml){
        
        self.xmlResult = nil;
        
        NSData* xmlData=[xml dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        
        [parser setDelegate:self];
        [parser parse];
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onISEResultXmlParserResult:)]) {
            [self.delegate onISEResultXmlParserResult:self.xmlResult];
        }
    }
}


#pragma mark - tools


void readTotalResult(ISEResult* result, NSDictionary* attrDic) {
    result.beg_pos = [[attrDic objectForKey:@"beg_pos"] intValue];
    result.end_pos = [[attrDic objectForKey:@"end_pos"] intValue];
    result.content = [attrDic objectForKey:@"content"];
    result.total_score = [[attrDic objectForKey:@"total_score"] floatValue];
    result.time_len = [[attrDic objectForKey:@"time_len"] intValue];
    result.except_info = [attrDic objectForKey:@"except_info"];
    result.is_rejected = [[attrDic objectForKey:@"is_rejected"] boolValue];
}

ISEResultPhone* createPhone(NSDictionary* attrDic) {
    ISEResultPhone* phone=[[ISEResultPhone alloc] init];
    phone.beg_pos = [[attrDic objectForKey:@"beg_pos"] intValue];
    phone.end_pos = [[attrDic objectForKey:@"end_pos"] intValue];
    phone.content = [attrDic objectForKey:@"content"];
    phone.dp_message = [[attrDic objectForKey:@"dp_message"] intValue];
    phone.time_len = [[attrDic objectForKey:@"time_len"] intValue];
    return phone;
}

ISEResultSyll* createSyll(NSDictionary* attrDic) {
    ISEResultSyll* syll=[[ISEResultSyll alloc] init];
    syll.beg_pos = [[attrDic objectForKey:@"beg_pos"] intValue];
    syll.end_pos = [[attrDic objectForKey:@"end_pos"] intValue];
    syll.content = [attrDic objectForKey:@"content"];
    syll.symbol = [attrDic objectForKey:@"symbol"];
    syll.dp_message = [[attrDic objectForKey:@"dp_message"] intValue];
    syll.time_len = [[attrDic objectForKey:@"time_len"] intValue];
    return syll;
}

ISEResultWord* createWord(NSDictionary* attrDic) {
    ISEResultWord* word=[[ISEResultWord alloc] init];
    word.beg_pos = [[attrDic objectForKey:@"beg_pos"] intValue];
    word.end_pos = [[attrDic objectForKey:@"end_pos"] intValue];
    word.content = [attrDic objectForKey:@"content"];
    word.symbol =  [attrDic objectForKey:@"symbol"];
    word.dp_message = [[attrDic objectForKey:@"dp_message"] intValue];
    word.time_len = [[attrDic objectForKey:@"time_len"] intValue];
    word.total_score = [[attrDic objectForKey:@"total_score"] floatValue];
    word.global_index = [[attrDic objectForKey:@"global_index"] intValue];
    word.index = [[attrDic objectForKey:@"index"] intValue];
    return word;
}

ISEResultSentence* createSentence(NSDictionary* attrDic) {
    ISEResultSentence* sentence=[[ISEResultSentence alloc] init];;
    sentence.beg_pos = [[attrDic objectForKey:@"beg_pos"] intValue];
    sentence.end_pos = [[attrDic objectForKey:@"end_pos"] intValue];
    sentence.content = [attrDic objectForKey:@"content"];
    sentence.time_len = [[attrDic objectForKey:@"time_len"] intValue];
    sentence.index = [[attrDic objectForKey:@"index"] intValue];
    sentence.word_count = [[attrDic objectForKey:@"word_count"] intValue];
    return sentence;
}

#pragma mark - NSXMLParser delegate
- (void) parserDidStartDocument:(NSXMLParser *)parser{
}

- (void) parserDidEndDocument:(NSXMLParser *)parser{
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict{
    
    
    //complete
    if([@"rec_paper" isEqualToString:elementName]){
        _isRecPaperPassed=YES;
    }
    else if([@"read_syllable" isEqualToString:elementName]){
        if(!_isRecPaperPassed){
             _xmlResult=[[ISEResultReadSyllable alloc] init];
        }
        else{
            readTotalResult(self.xmlResult, attributeDict);
        }
        
    }
    else if([@"read_word" isEqualToString:elementName]){
        if(!_isRecPaperPassed){
            _xmlResult=[[ISEResultReadWord alloc] init];
            NSString* lan=[attributeDict objectForKey:@"lan"];
            _xmlResult.language=lan?lan:@"cn";
        }
        else{
            readTotalResult(self.xmlResult, attributeDict);
        }
        
    }
    else if([@"read_sentence" isEqualToString:elementName]||[@"read_chapter" isEqualToString:elementName]){
        if(!_isRecPaperPassed){
            _xmlResult=[[ISEResultReadSentence alloc] init];
            NSString* lan=[attributeDict objectForKey:@"lan"];
            _xmlResult.language=lan?lan:@"cn";
        }
        else{
            readTotalResult(self.xmlResult, attributeDict);
        }
        
    }
    else if([@"sentence" isEqualToString:elementName]){
        if(_xmlResult&&!_xmlResult.sentences){
            _xmlResult.sentences=[[NSMutableArray alloc] init];
        }
        _sentence=createSentence(attributeDict);
    }
    else if([@"word" isEqualToString:elementName]){
        if(_sentence && !_sentence.words){
            _sentence.words=[[NSMutableArray alloc] init];
        }
        _word=createWord(attributeDict);
    }
    else if([@"syll" isEqualToString:elementName]){
        if(_word && !_word.sylls){
            _word.sylls=[[NSMutableArray alloc] init];
        }
        _syll=createSyll(attributeDict);
    }
    else if([@"phone" isEqualToString:elementName]){
        if(_syll && !_syll.phones){
            _syll.phones=[[NSMutableArray alloc] init];
        }
        _phone=createPhone(attributeDict);
    }
    
    //plain
    if([@"FinalResult" isEqualToString:elementName]){
        self.isPlainResult=YES;
        _xmlResult = [[ISEResultFinal alloc] init];
    }
    else if([@"ret" isEqualToString:elementName]){
        [(ISEResultFinal *)_xmlResult setRet:[[attributeDict objectForKey:@"value"] intValue]];
    }
    else if([@"total_score" isEqualToString:elementName]){
        [(ISEResultFinal *)_xmlResult setTotal_score:[[attributeDict objectForKey:@"value"] floatValue]];
    }
    else if([@"xml_result" isEqualToString:elementName]){
        self.isPlainResult=NO;
    }
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
}

- (void) parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString{
    
}



- (void) parser:(NSXMLParser *) parser
  didEndElement:(NSString *) elementName
   namespaceURI:(NSString *) namespaceURI
  qualifiedName:(NSString *) qualifiedName{

    
    if([@"phone" isEqualToString:elementName]){
        [_syll.phones addObject:_phone];
        _phone=nil;
    }
    else if([@"syll" isEqualToString:elementName]){
        [_word.sylls addObject:_syll];
        _syll=nil;
    }
    else if([@"word" isEqualToString:elementName]){
        [_sentence.words addObject:_word];
        _word=nil;
    }
    else if([@"sentence" isEqualToString:elementName]){
        [_xmlResult.sentences addObject:_sentence];
        _sentence=nil;
    }
    else if([@"read_syllable" isEqualToString:elementName] ||
            [@"read_word" isEqualToString:elementName] ||
            [@"read_sentence" isEqualToString:elementName] ||
            [@"read_chapter" isEqualToString:elementName] ||
            [@"FinalResult" isEqualToString:elementName] ){
        
        [parser abortParsing];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onISEResultXmlParserResult:)]) {
            [self.delegate onISEResultXmlParserResult:self.xmlResult];
        }
    }
    
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onISEResultXmlParser:Error:)]) {
        [self.delegate onISEResultXmlParser:parser Error:parseError];
    }
}

@end

