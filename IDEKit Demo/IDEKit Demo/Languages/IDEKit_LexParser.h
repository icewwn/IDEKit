//
//  IDEKit_Parser.h
//  IDEKit
//
//  Created by Glenn Andreas on Mon May 26 2003.
//  Copyright (c) 2003, 2004 by Glenn Andreas
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Library General Public
//  License as published by the Free Software Foundation; either
//  version 2 of the License, or (at your option) any later version.
//  
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Library General Public License for more details.
//  
//  You should have received a copy of the GNU Library General Public
//  License along with this library; if not, write to the Free
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

#import <Cocoa/Cocoa.h>

extern NSString *IDEKit_LexIDKey;
extern NSString *IDEKit_LexColorKey;

extern NSString *IDEKit_LexParserStartState;
@protocol IDEKit_LexParserColorer
- (NSColor *)colorForIdentifier: (NSString *)ident;
@end

enum {
    IDEKit_kLexKindMask = 	0x0fff0000,
    IDEKit_kLexIDMask = 	0x0000ffff,

    IDEKit_kLexKindOperator = 	0x00000000, // so '+' is actaully then '+'
    IDEKit_kLexKindKeyword = 	0x00010000, // this includes explicit operators
    IDEKit_kLexKindPrePro = 	0x00020000,
    IDEKit_kLexKindSpecial = 	0x0fff0000,
    
    IDEKit_kLexEOF = IDEKit_kLexKindSpecial | 0,
    IDEKit_kLexError = IDEKit_kLexKindSpecial | 1,
    IDEKit_kLexWhiteSpace = IDEKit_kLexKindSpecial | 2,
    IDEKit_kLexEOL = IDEKit_kLexKindSpecial | 3,
    IDEKit_kLexComment = IDEKit_kLexKindSpecial | 4,
//    IDEKit_kLexPreProcessor = -5,
    IDEKit_kLexString = IDEKit_kLexKindSpecial | 6,
    IDEKit_kLexCharacter = IDEKit_kLexKindSpecial | 7,
    IDEKit_kLexNumber = IDEKit_kLexKindSpecial | 8,
//    IDEKit_kLexOperator = IDEKit_kLexKindSpecial | 9,
    IDEKit_kLexIdentifier = IDEKit_kLexKindSpecial | 10,
    // for markup languages, we treat "content" as differnet than markup
    IDEKit_kLexMarkupStart = IDEKit_kLexKindSpecial | 11,
    IDEKit_kLexMarkupEnd = IDEKit_kLexKindSpecial | 12,
    IDEKit_kLexContent = IDEKit_kLexKindSpecial | 13, // what is like a string between the markup
    IDEKit_kLexToken = IDEKit_kLexKindKeyword, // for a token, we normally return the lexID, unless it is 0, when we return IDEKit_kLexToken
};

@class IDEKit_TokenEnumerator;

@interface IDEKit_LexParser : NSObject {
    NSMutableDictionary *myKeywords;	// both regular and alt
    NSMutableDictionary *myOperators;

    NSString *myPreProStart;
    NSMutableArray *myPreProcessor;

    NSMutableArray *myStrings;
    NSMutableArray *myCharacters;
    NSMutableArray *myMultiComments;
    NSMutableArray *mySingleComments;
    NSString *myMarkupStart;
    NSString *myMarkupEnd;

    NSCharacterSet *myIdentifierChars;
    NSCharacterSet *myFirstIdentifierChars;
    
    NSUInteger myCurLoc;
    NSUInteger myStopLoc;
    NSUInteger myCurState;
    NSUInteger mySubStart;
    NSString *myCloser;
    NSInteger mySubColor;
    NSInteger mySubLexID;
    NSString *myString;
    BOOL doneWithToken;
    BOOL myCaseSensitive;
    NSInteger myTempBackState;
}
- (void) setCaseSensitive: (BOOL) sensitive;
- (id) addKeyword: (NSString *)string color: (NSInteger) color lexID: (NSInteger) lexID;
- (id) addOperator: (NSString *)string lexID: (NSInteger) lexID;
- (void) addStringStart: (NSString *)start end: (NSString *) end;
- (void) addCharacterStart: (NSString *)start end: (NSString *) end;
- (void) addCommentStart: (NSString *)start end: (NSString *) end;
- (void) addMarkupStart: (NSString *)start end: (NSString *) end;
- (void) addSingleComment: (NSString *)start;
- (void) setIdentifierChars: (NSCharacterSet *)set;
- (void) setFirstIdentifierChars: (NSCharacterSet *)set;
- (void) setPreProStart: (NSString *)start;
- (void) addPreProcessor: (NSString *)token;

- (void) colorString: (NSMutableAttributedString *)string range: (NSRange) range colorer: (id) colorer;
- (void) startParsingString: (NSString *)string range: (NSRange) range;
- (NSInteger) parseOneToken: (NSRangePointer) result ignoreWhiteSpace: (BOOL) ignoreWS;
@end
