//
//  IDEKit_LanguagePlugins.mm
//  IDEKit
//
//  Created by Glenn Andreas on Sat Feb 08 2003.
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
#import "IDEKit_CLanguagePlugins.h"
#import "IDEKit_LexParser.h"
#import "IDEKit_TextColors.h"
#import "IDEKit_Delegate.h"

#define STATICREGEX(name,pattern) \
static regex_t *name = NULL;\
if (!name) { \
    name = new regex_t; \
	if (regcomp(name,pattern,REG_EXTENDED)) { \
	    delete name; \
		name = nil; \
	} \
}

enum {
    kC_pragma = 1,
    kC_mark = 2,
    kC_void = 3,
    kC_type = 4,
    kC_typemod = 5,
};

@implementation IDEKit_CLanguage
+ (void)load
{
    [IDEKit_GetLanguagePlugIns() addObject: self];
}

+ (IDEKit_LexParser *)makeLexParser
{
    IDEKit_LexParser *lex = [[IDEKit_LexParser alloc] init];
    [lex addKeyword: @"asm" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"do" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"if" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"return" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"typedef" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"auto" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"double" color: IDEKit_kLangColor_Keywords lexID: kC_type];
    [lex addKeyword: @"short" color: IDEKit_kLangColor_Keywords lexID: kC_type];
    [lex addKeyword: @"int" color: IDEKit_kLangColor_Keywords lexID: kC_type];
    [lex addKeyword: @"signed" color: IDEKit_kLangColor_Keywords lexID: kC_typemod];
    [lex addKeyword: @"typename" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"break" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"else" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"long" color: IDEKit_kLangColor_Keywords lexID: kC_type];
    [lex addKeyword: @"sizeof" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"union" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"case" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"enum" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"static" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"NSUInteger" color: IDEKit_kLangColor_Keywords lexID: kC_typemod];
    [lex addKeyword: @"char" color: IDEKit_kLangColor_Keywords lexID: kC_type];
    [lex addKeyword: @"export" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"struct" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"extern" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"switch" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"void" color: IDEKit_kLangColor_Keywords lexID: kC_void];
    [lex addKeyword: @"const" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"float" color: IDEKit_kLangColor_Keywords lexID: kC_type];
    [lex addKeyword: @"continue" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"for" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"while" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"default" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"register" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"goto" color: IDEKit_kLangColor_Keywords lexID: 0];
    // and alternates
    [lex addKeyword: @"__asm__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__label__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"typeof" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__complex__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__real__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__imag__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__attribute__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__alignof__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__extension__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"__restrict__" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"FALSE" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"NULL" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"TRUE" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    // pre-processor
    [lex setPreProStart: @"#"];
    [lex addPreProcessor: @"define"];
    [lex addPreProcessor: @"elif"];
    [lex addPreProcessor: @"else"];
    [lex addPreProcessor: @"endif"];
    [lex addPreProcessor: @"file"];
    [lex addPreProcessor: @"error"];
    [lex addPreProcessor: @"if"];
    [lex addPreProcessor: @"ifdef"];
    [lex addPreProcessor: @"ifndef"];
    [lex addPreProcessor: @"import"];
    [lex addPreProcessor: @"include"];
    [lex addPreProcessor: @"line"];
    [lex addPreProcessor: @"pragma"];
    [lex addPreProcessor: @"undef"];
    [lex addPreProcessor: @"warning"];
    // now the rest of the info
    [lex addStringStart: @"\"" end: @"\""];
    [lex addCharacterStart: @"'" end: @"'"];
    [lex addCommentStart: @"/*" end: @"*/"];
    [lex addSingleComment: @"//"];
    [lex setIdentifierChars: [NSCharacterSet characterSetWithCharactersInString: @"_"]];
    
    return lex;
}
- (NSString *) getLinePrefixComment
{
    return @"///"; // use modified C++ comment
}

+ (NSString *)languageName
{
    return @"C";
}

+ (BOOL)isYourFile: (NSString *)name
{
    if ([[name pathExtension] isEqualToString: @"c"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"h"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"C"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"H"])
	return YES;
    return NO;
}

- (BOOL)wantsBreakpoints
{
    // we are a programming language, let IDE delegate determine if debugger available for us
    return [IDEKit languageSupportDebugging: self];
}

- (NSInteger) autoIndentLine: (NSString *)thisList last: (NSString *)lastLine
{
    // not perfect by a long shot...
    if ([[lastLine stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] hasSuffix: @"{"]) {
	return IDEKit_kIndentAction_Indent;
    }
    if ([[thisList stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] hasSuffix: @"}"]) {
	return IDEKit_kIndentAction_Dedent;
    }
    return IDEKit_kIndentAction_None;
}


- (NSString *) complete: (NSString *)name withParams: (NSArray *)array
{
    if ([name isEqualToString: @"if"]) {
	return @"if ($</*condition*/$>) {$+$</*true block*/$>$-}";
    } else if ([name isEqualToString: @"ife"]) {
	return @"if ($</*condition*/$>) {$+$</*true block*/$>$-} else {$+$</*true block*/$>$-}";
    } else if ([name isEqualToString: @"while"]) {
	return @"while ($</*condition*/$>) {$+$</*loop block*/$>$-}";
    } else if ([name isEqualToString: @"for"]) {
	return @"for ($</*init*/$>;$</*condition*/$>;$</*next*/$>) {$+$</*loop block*/$>$-}";
    } else if ([name isEqualToString: @"switch"]) {
	return @"switch ($</*expr*/$>) {$=$<case$>$=default:$+$</*default case*/$>$=break;$-}";
    } else if ([name isEqualToString: @"case"]) {
	return @"case $</*value*/$> : $+$</*case body*/$>$=break;$-$<case$>";
    }
    return nil;
}

- (NSArray *)functionList: (NSString *)source // for popup funcs - return a list of TextFunctionMarkers
{
#ifdef nodef
    STATICREGEX(pragmas,"#pragma mark (([[:print:]]|[[:blank:]])*)");
    if (!pragmas)
	return nil;
    //NSLog(@"Checking for mark");
    // we've got something to parse?
    NSMutableArray *retval = [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: nil
											fromRegex: pragmas withNameIn: 1];
    //	[[:alnum:]_]+[[:space:]*&]*([[:alpha:]_][[:alnum:]_]*)[[:space:]]*\([[:alnum:][:space:],_*&]*\)[[:space:]]*{ //
    //	STATICREGEX(functions,"[[:alnum:]_]+[[:space:]*&]*"
    //						"([[:alpha:]_][[:alnum:]_]*)"
    //						"[[:space:]]*\\([[:alnum:][:space:],_*&]\\)[[:space:]]*{");
    STATICREGEX(functions,"[[:alnum:]_]+[[:space:]*&]+([[:alpha:]_][[:alnum:]_]*)[[:space:]]*\\([[:alnum:][:space:],_*&]*\\)[[:space:]]*{");
    if (!functions)
	return retval;
    retval = [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: retval
													   fromRegex: functions withNameIn: 1];
    return retval;
    //	NSLog(@"Returning %@",retval);
#else
#ifdef nodef
    int pattern[] = {
	//IDEKit_kMarkerBeginPattern, IDEKit_kMarkerBOL,kC_pragma,kC_mark,IDEKit_kMarkerTextStart,IDEKit_kMarkerUntilEOL,IDEKit_kMarkerEndPattern,
	IDEKit_kMarkerBeginPattern,IDEKit_kLexIdentifier,IDEKit_kMarkerTextStart,IDEKit_kLexIdentifier,IDEKit_kMarkerTextEnd,'(',IDEKit_kMarkerAnyUntil,')','{',IDEKit_kMarkerEndPattern,
	IDEKit_kMarkerBeginPattern,IDEKit_kLexIdentifier,IDEKit_kMarkerMatchBegin,'*','&',IDEKit_kMarkerMatchEnd,IDEKit_kMarkerTextStart,IDEKit_kLexIdentifier,IDEKit_kMarkerTextEnd,'(',IDEKit_kMarkerAnyUntil,')','{',IDEKit_kMarkerEndPattern,
	IDEKit_kMarkerEndList
    };
#else
    int pattern[] = {
	//IDEKit_kMarkerBeginPattern, IDEKit_kMarkerBOL,kC_pragma,kC_mark,IDEKit_kMarkerTextStart,IDEKit_kMarkerUntilEOL,IDEKit_kMarkerEndPattern,
	IDEKit_MATCH_PATTERN(IDEKit_kLexIdentifier,IDEKit_kMarkerTextStart,IDEKit_kLexIdentifier,IDEKit_kMarkerTextEnd,'(',IDEKit_MATCH_UNTIL(')'),'{'),
	IDEKit_MATCH_PATTERN(IDEKit_kLexIdentifier,IDEKit_MATCH_ANY('*','&'),IDEKit_kMarkerTextStart,IDEKit_kLexIdentifier,IDEKit_kMarkerTextEnd,'(',IDEKit_MATCH_UNTIL(')'),'{'),
	IDEKit_kMarkerEndList
    };
#endif
    return [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: nil fromPattern: pattern withLex: myParser];
#endif
}

@end

enum {
    kObjC_Markable = 300,
    kObjC_Type = 301,
};

static void AddObjCLexer(IDEKit_LexParser *lex)
{
    [lex addKeyword: @"@class" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"@defs" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"@encode" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"@end" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"@interface" color: IDEKit_kLangColor_Keywords lexID: kObjC_Markable];
    [lex addKeyword: @"@implementation" color: IDEKit_kLangColor_Keywords lexID: kObjC_Markable];
    [lex addKeyword: @"@private" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"@protected" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"@protocol" color: IDEKit_kLangColor_Keywords lexID: kObjC_Markable];
    [lex addKeyword: @"@public" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"@selector" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"IMP" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"SEL" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"bycopy" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"byref" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"id" color: IDEKit_kLangColor_Keywords lexID: kObjC_Type];
    [lex addKeyword: @"in" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"inout" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"oneway" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"out" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"self" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"super" color: IDEKit_kLangColor_Keywords lexID: 0];

    [lex addKeyword: @"BOOL" color: IDEKit_kLangColor_AltKeywords lexID: kObjC_Type];
    [lex addKeyword: @"IBAction" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"IBOutlet" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"Nil" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"NO" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"NS_DURING" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"NS_ENDHANDLER" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"NS_VALUERETURN" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"NS_VOIDRETURN" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"YES" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex addKeyword: @"nil" color: IDEKit_kLangColor_AltKeywords lexID: 0];
    [lex setIdentifierChars: [NSCharacterSet characterSetWithCharactersInString: @"@_"]];
}

static NSArray *AddObjCMarks(NSMutableArray *base, IDEKit_LexParser *lex, NSString *source)
{
    int pattern[] = {
	IDEKit_MATCH_PATTERN(IDEKit_MATCH_KEYWORD(kObjC_Markable),IDEKit_kLexIdentifier),
	IDEKit_MATCH_PATTERN(
		      IDEKit_MATCH_ANY('+','-'),
		      '(',
		      IDEKit_MATCH_ANY(
			 IDEKit_kLexIdentifier,IDEKit_MATCH_KEYWORD(kObjC_Type),IDEKit_MATCH_KEYWORD(kC_type),IDEKit_MATCH_KEYWORD(kC_void),IDEKit_MATCH_KEYWORD(kC_typemod)
			 ),
		      IDEKit_MATCH_OPT('*'),
		      ')',
		      IDEKit_kLexIdentifier,IDEKit_MATCH_OPT(':')
		      ),
	IDEKit_kMarkerEndList
    };
    return [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: base fromPattern: pattern withLex: lex];
}

@implementation IDEKit_ObjectiveCLanguage
+ (void)load
{
    [IDEKit_GetLanguagePlugIns() addObject: self];
}
+ (NSString *)languageName
{
    return @"Objective C";
}
+ (IDEKit_LexParser *)makeLexParser
{
    IDEKit_LexParser *retval = [super makeLexParser];
    AddObjCLexer(retval);
    return retval;
}
+ (BOOL)isYourFile: (NSString *)name
{
    if ([[name pathExtension] isEqualToString: @"m"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"h"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"M"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"H"])
	return YES;
    return NO;
}
- (NSString *) complete: (NSString *)name withParams: (NSArray *)array
{
    if ([name isEqualToString: @"intf"]) {
	return @"@interface $</*class name*/$> : $</*parent class*/$>$={$+$</*Instance Variables*/$>$-}$=$</*methods*/$>$=@end";
    } else if ([name isEqualToString: @"impl"]) {
	return @"@interface /*class name*/$={$+/*Instance Variables*/$-}$=$</*methods*/$>$=@end";
    } else if ([name isEqualToString: @"proto"]) {
	return @"@protocol $</*protocol name*/$>$=$</*methods*/$>$=@end";
    }
    return [super complete: name withParams: array];
}

#define OBJCMARKER \
	"(@interface[[:blank:]]*[a-zA-Z0-9_]*([[:blank:]]*\\([^)]+\\))*)|"\
	"(@protocol[[:blank:]]*[a-zA-Z0-9_]*)|"\
	"(@implementation[[:blank:]]*[a-zA-Z0-9_]*)|"\
	"([+-][[:blank:]]*\\([^)]+\\)([a-zA-Z0-9_:]+))"
//	"[+-][[:blank:]]*\\([[:blank:][:alnum:]*]*\\)[a-zA-Z0-9_:]+"
//	"@implementation[[:blank:]]*([[:graph:]]+)"
- (NSArray *)functionList: (NSString *)source // for popup funcs - return a list of TextFunctionMarkers
{
#ifdef nodef
    STATICREGEX(objcmarkers,OBJCMARKER);
    NSMutableArray *retval = (NSMutableArray *)[super functionList: source];
    if (!objcmarkers)
	return retval;
    return [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: nil
								     fromRegex: objcmarkers withNameIn: 0];
#else
    NSMutableArray *retval = (NSMutableArray *)[super functionList: source];
    return AddObjCMarks(retval,myParser,source);
#endif
}

@end
@implementation IDEKit_CPPLanguage
+ (void)load
{
    [IDEKit_GetLanguagePlugIns() addObject: self];
}
#define CPPRESERVEDWORDS \
	"[[:<:]](inline|typeid|bool" \
	"|dynamic_cast|mutable"\
	"|catch|explicit|namespace|static_cast|using"\
	"|new|virtual|class|operator|false|private"\
	"|template|volatile|const_cast|protected|this|wchar_t|public"\
	"|throw|friend|true|delete|reinterpret_cast|try)[[:>:]]"
+ (NSString *)languageName
{
    return @"C++";
}
+ (IDEKit_LexParser *)makeLexParser
{
    IDEKit_LexParser *lex = [[IDEKit_CLanguage class] makeLexParser];
    [lex addKeyword: @"abstract" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"bool" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"catch" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"const_cast" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"delete" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"dynamic_cast" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"explicit" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"false" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"friend" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"mutable" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"namespace" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"new" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"operator" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"private" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"protected" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"public" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"retinterpret_cast" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"static_cast" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"template" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"this" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"throw" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"true" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"try" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"typeid" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"typename" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"using" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"virtual" color: IDEKit_kLangColor_Keywords lexID: 0];
    [lex addKeyword: @"wchar_t" color: IDEKit_kLangColor_Keywords lexID: 0];
    return lex;
}
#ifdef nomore
- (IDEKit_LexParser *)lexParser
{
    static IDEKit_LexParser *gLex = NULL;
    if (!gLex) {
	gLex = [[[self class] makeLexParser] retain];
    }
    return gLex;
}
#endif

+ (BOOL)isYourFile: (NSString *)name
{
    if ([[name pathExtension] isEqualToString: @"cp"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"cpp"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"h"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"CP"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"CPP"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"H"])
	return YES;
    return NO;
}
//#define CPPMARKER "(class[[::blank::]]+([a-zA-Z0-9_]+))|"
#define CPPMARKER "[[:alnum:]_]+[[:space:]*&]+([[:alpha:]_][[:alnum:]_]*[[:space:]]*::[[:alpha:]_][[:alnum:]_]*)[[:space:]]*\\([[:alnum:][:space:],_*&]*\\)[[:space:]]*{"

- (NSArray *)functionList: (NSString *)source // for popup funcs - return a list of TextFunctionMarkers
{
#ifdef nodef
    NSMutableArray *retval = (NSMutableArray *)[super functionList: source]; // get the C marks
    STATICREGEX(cppmarkers,CPPMARKER);
    if (!cppmarkers)
	return retval;
    retval = [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: retval
		    fromRegex: cppmarkers withNameIn: 1];
    return retval;
#else
    NSMutableArray *retval = (NSMutableArray *)[super functionList: source];
    int pattern[] = {
	//IDEKit_kMarkerBeginPattern, IDEKit_kMarkerBOL,kC_pragma,kC_mark,IDEKit_kMarkerTextStart,IDEKit_kMarkerUntilEOL,IDEKit_kMarkerEndPattern,
	IDEKit_kMarkerBeginPattern,IDEKit_kLexIdentifier,IDEKit_kMarkerTextStart,IDEKit_kLexIdentifier,':',':',IDEKit_kLexIdentifier,IDEKit_kMarkerTextEnd,'(',IDEKit_kMarkerAnyUntil,')','{',IDEKit_kMarkerEndPattern,
	IDEKit_kMarkerBeginPattern,IDEKit_kLexIdentifier,IDEKit_kMarkerMatchBegin,'*','&',IDEKit_kMarkerMatchEnd,IDEKit_kMarkerTextStart,IDEKit_kLexIdentifier,':',':',IDEKit_kLexIdentifier,IDEKit_kMarkerTextEnd,'(',IDEKit_kMarkerAnyUntil,')','{',IDEKit_kMarkerEndPattern,
	IDEKit_kMarkerEndList
    };
    return [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: retval fromPattern: pattern withLex: myParser];
    return retval;
#endif
}
@end
@implementation IDEKit_ObjectiveCPPLanguage
+ (void)load
{
    [IDEKit_GetLanguagePlugIns() addObject: self];
}
+ (NSString *)languageName
{
    return @"Objective C++";
}
+ (IDEKit_LexParser *)makeLexParser
{
    IDEKit_LexParser *retval = [super makeLexParser];
    AddObjCLexer(retval);
    return retval;
}

- (NSString *) complete: (NSString *)name withParams: (NSArray *)array
{
    if ([name isEqualToString: @"intf"]) {
	return @"@interface $</*class name*/$> : $</*parent class*/$>$={$+$</*Instance Variables*/$>$-}$=$</*methods*/$>$=@end";
    } else if ([name isEqualToString: @"impl"]) {
	return @"@interface /*class name*/$={$+/*Instance Variables*/$-}$=$</*methods*/$>$=@end";
    } else if ([name isEqualToString: @"proto"]) {
	return @"@protocol $</*protocol name*/$>$=$</*methods*/$>$=@end";
    }
    return [super complete: name withParams: array];
}

+ (BOOL)isYourFile: (NSString *)name
{
    if ([[name pathExtension] isEqualToString: @"cp"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"cpp"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"h"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"m"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"mm"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"CP"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"CPP"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"H"])
	return YES;
    if ([[name pathExtension] isEqualToString: @"MM"])
	return YES;
    return NO;
}

- (NSArray *)functionList: (NSString *)source // for popup funcs - return a list of TextFunctionMarkers
{
#ifdef nodef
    NSMutableArray *retval = (NSMutableArray *)[super functionList: source]; // get the C marks
    	// add the objective C ones
    STATICREGEX(objcmarkers,OBJCMARKER);
    if (!objcmarkers)
	return retval;
    retval = [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: retval
								       fromRegex: objcmarkers withNameIn: 0];
    STATICREGEX(cppmarkers,CPPMARKER);
    if (!cppmarkers)
	return retval;
    retval = [IDEKit_TextFunctionMarkers makeAllMarks: source inArray: retval
	    fromRegex: cppmarkers withNameIn: 1];
    return retval;
#else
    NSMutableArray *retval = (NSMutableArray *)[super functionList: source];
    return AddObjCMarks(retval,myParser,source);
#endif
		
}
@end
