//
//  Utilities.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <objc/runtime.h>

#import "Utilities.h"

@implementation Utilities

CGRect SameSizeRectAt(CGFloat x, CGFloat y, CGRect rect){
    return CGRectMake(x, y, rect.size.width, rect.size.height);
}

CGRect SameOriginRectWithSize(CGFloat width, CGFloat height, CGRect rect){
    return CGRectMake(rect.origin.x, rect.origin.y, width, height);
}

CGRect RectWithNewHeight(CGFloat height, CGRect rect){
    return SameOriginRectWithSize(rect.size.width, height, rect);
}

+(void)showOkAlertWithTitle:(NSString *)title message:(NSString *)message{
	UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:title
                           message:message
                           delegate:nil
                           cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                           otherButtonTitles:nil];
	[alert show];
}

+(void)showOkAlertWithError:(NSError *)error{
    
}

+(CGFloat)heightForString:(NSString *)str withFont:(UIFont *)font width:(CGFloat)width{
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize labelSize = [str sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height;
}

+(NSString *)pluralize:(NSNumber *)num singular:(NSString *)singular plural:(NSString *)plural{
    return ([num intValue] == 1) ? singular : plural;
}

//This gives a dictionary containing the properties of a class, as well as their types
//Used to dynamically create or parse from XML for subclasses of Resource
+ (NSDictionary *)classPropsFor:(Class)klass{
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    Class superClass = class_getSuperclass(klass);
    if (superClass != nil && ![superClass isEqual:[NSObject class]]){
        [results addEntriesFromDictionary:[self classPropsFor:superClass]];
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [[NSString alloc] initWithUTF8String:propName];
            NSString *propertyType = [[NSString alloc] initWithUTF8String:propType];
            
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    return results;
}

//returns the type of a given an objective c property
static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}



@end
