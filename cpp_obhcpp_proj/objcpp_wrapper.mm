//
//  objcpp_wrapper.m
//  cpp_obhcpp_proj
//
//  Created by Flynn on 10/20/17.
//  Copyright © 2017 Flynn. All rights reserved.
//

#import "objcpp_wrapper.h"
#include "junk.h"
#include "decode.h"


@implementation MyOCPPClass

- (int)printHelloWorldFromCPP {
    return hello();
}

@end
