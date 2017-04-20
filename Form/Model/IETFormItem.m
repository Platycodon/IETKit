//
//  IETFormItem.m
//  IETKitTest
//
//  Created by 陆楠 on 2017/4/17.
//  Copyright © 2017年 lunan. All rights reserved.
//

#import "IETFormItem.h"
#import "YYModel.h"
#import <objc/message.h>
#import "IETModel.h"

@interface IETFormItem ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bindingKey;
@property (nonatomic, weak) IETModel *bindingModel;
@property (nonatomic, strong) YYClassPropertyInfo *propertyInfo;

- (void)initValue;
- (void)initPropertyInfo;

@end

@implementation IETFormItem
{
    BOOL _propertyInited;
    BOOL _valueInited;
}

+ (instancetype)itemWithTitle:(NSString *)title bindingKey:(NSString *)key isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model placeHolder:(NSString *)placeHolder {
    
    IETFormItem *item = [IETFormItem new];
    [item setTitle:title bindingKey:key isMandatory:isMandatory isEditable:isEditable bindingModel:model placeHolder:placeHolder];
    return item;
}

- (void)setTitle:(NSString *)title bindingKey:(NSString *)key isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model placeHolder:(NSString *)placeHolder {
    
    self.title = title;
    self.bindingKey = key;
    self.isMandatory = isMandatory;
    self.isEditable = isEditable;
    self.bindingModel = model;
    self.placeHolder = placeHolder;
}

- (void)setBindingKey:(NSString *)bindingKey {
    
    _bindingKey = bindingKey;
    if (_bindingModel != nil && _propertyInited == NO) {
        [self initPropertyInfo];
    }
    if (_bindingModel != nil && _valueInited == NO) {
        [self initValue];
    }
}

- (void)setBindingModel:(IETModel *)bindingModel {
    
    _bindingModel = bindingModel;
    if (_bindingKey != nil && _propertyInited == NO) {
        [self initPropertyInfo];
    }
    if (_bindingKey != nil && _valueInited == NO) {
        [self initValue];
    }
}

- (void)initPropertyInfo {//初始化所绑定的属性信息
    
    Class cls = [_bindingModel class];
    while (cls != [NSObject class]) {
        BOOL find = NO;
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([cls class], &outCount);
        objc_property_t property = NULL;
        for (int i=0; i<outCount; i++) {
            property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
            if ([key isEqualToString:_bindingKey]) {
                find = YES;
                break;
            }
        }
        if (find) {
            _propertyInfo = [[YYClassPropertyInfo alloc] initWithProperty:property];
            _propertyInited = YES;
            break;
        }else{
            cls = class_getSuperclass(cls);
        }
        free(properties);
        if (property && find) {
            free(property);
        }
    }
}

- (void)initValue {
    
    if (_propertyInfo.cls) { //不是nil 表示不是基础数据类型而是个类
        _value = ((id (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
    }else{
        switch (_propertyInfo.type & YYEncodingTypeMask) {
            case YYEncodingTypeBool: {
                bool num = ((bool (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = @(num).stringValue;
            } break;
            case YYEncodingTypeInt8:
            case YYEncodingTypeUInt8: {
                uint8_t num = ((uint8_t (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = num==0?nil:@(num).stringValue;
            } break;
            case YYEncodingTypeInt16:
            case YYEncodingTypeUInt16: {
                uint16_t num = ((uint16_t (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = num==0?nil:@(num).stringValue;
            } break;
            case YYEncodingTypeInt32:
            case YYEncodingTypeUInt32: {
                uint32_t num = ((uint32_t (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = num==0?nil:@(num).stringValue;
            } break;
            case YYEncodingTypeInt64:
            case YYEncodingTypeUInt64: {
                uint64_t num = ((uint64_t (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = num==0?nil:@(num).stringValue;
            } break;
            case YYEncodingTypeFloat: {
                float num = ((float (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = num==0?nil:@(num).stringValue;
            } break;
            case YYEncodingTypeDouble: {
                double num = ((double (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = num==0?nil:@(num).stringValue;
            } break;
            case YYEncodingTypeLongDouble: {
                long double num = ((long double (*)(id, SEL))(void *) objc_msgSend)(_bindingModel, _propertyInfo.getter);
                _value = num==0?nil:[NSString stringWithFormat:@"%Lf",num];
            }
            default: break;
        }
    }
}

- (void)updateValueToModel {
    
    if (_propertyInfo.cls) { //不是nil 表示不是基础数据类型而是个类
        ((void (*)(id, SEL, id))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, _value);
    }else if ([_value isKindOfClass:[NSString class]]){
        NSString *value = (NSString *)_value;
        switch (_propertyInfo.type & YYEncodingTypeMask) {
            case YYEncodingTypeBool: {
                ((void (*)(id, SEL, bool))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.boolValue);
            } break;
            case YYEncodingTypeInt8:
            case YYEncodingTypeUInt8: {
                ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.intValue);
            } break;
            case YYEncodingTypeInt16:
            case YYEncodingTypeUInt16: {
                ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.intValue);
            } break;
            case YYEncodingTypeInt32:
            case YYEncodingTypeUInt32: {
                ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.intValue);
            } break;
            case YYEncodingTypeInt64:
            case YYEncodingTypeUInt64: {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.intValue);
            } break;
            case YYEncodingTypeFloat: {
                ((void (*)(id, SEL, float))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.floatValue);
            } break;
            case YYEncodingTypeDouble: {
                ((void (*)(id, SEL, double))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.doubleValue);
            } break;
            case YYEncodingTypeLongDouble: {
                ((void (*)(id, SEL, long double))(void *) objc_msgSend)(_bindingModel, _propertyInfo.setter, value.doubleValue);
            }
            default: break;
        }
    }
}

@end




@implementation IETFormFieldItem


+ (instancetype)itemWithTitle:(NSString *)title bindingKey:(NSString *)key isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model placeHolder:(NSString *)placeHolder {
    
    IETFormFieldItem *item = [IETFormFieldItem new];
    [item setTitle:title bindingKey:key isMandatory:isMandatory isEditable:isEditable bindingModel:model placeHolder:placeHolder];
    return item;
}

- (BOOL)checkRegex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",_regex];
    return [pre evaluateWithObject:self.value];
}

@end


@implementation IETFormPickItem

+ (instancetype)itemWithTitle:(NSString *)title bindingKey:(NSString *)key isMandatory:(BOOL)isMandatory isEditable:(BOOL)isEditable bindingModel:(IETModel *)model placeHolder:(NSString *)placeHolder dataSource:(id<USFormPickItemDataSource>)dataSource{
    
    IETFormPickItem *item = [IETFormPickItem new];
    [item setTitle:title bindingKey:key isMandatory:isMandatory isEditable:isEditable bindingModel:model placeHolder:placeHolder];
    item.dataSource = dataSource;
    return item;
}

@end




