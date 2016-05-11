#include "ResourcePath.h"
#include "Foundation/Foundation.h"

std::string ResourcePath(const std::string &resourceName, const std::string &resourceType)
{
    NSString *name = [NSString stringWithUTF8String:resourceName.c_str()];
    NSString *type = [NSString stringWithUTF8String:resourceType.c_str()];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    if (path)
    {
        return [path UTF8String];
    }
    else
    {
        return resourceName + "." + resourceType;
    }
}
