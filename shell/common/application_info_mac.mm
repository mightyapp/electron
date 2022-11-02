// Copyright (c) 2013 GitHub, Inc.
// Use of this source code is governed by the MIT license that can be
// found in the LICENSE file.

#import "shell/common/application_info.h"

#include <string>

#import "base/mac/foundation_util.h"
#import "base/strings/sys_string_conversions.h"
#import "shell/common/mac/main_application_bundle.h"

namespace electron {

namespace {

std::string ApplicationInfoDictionaryValue(
    NSString* key,
    NSBundle* bundle = MainApplicationBundle()) {
  return base::SysNSStringToUTF8([bundle.infoDictionary objectForKey:key]);
}

std::string ApplicationInfoDictionaryValue(
    CFStringRef key,
    NSBundle* bundle = MainApplicationBundle()) {
  return ApplicationInfoDictionaryValue(base::mac::CFToNSCast(key), bundle);
}

}  // namespace

std::string GetApplicationName() {
  return ApplicationInfoDictionaryValue(kCFBundleNameKey);
}

std::string GetApplicationVersion() {
  return ApplicationInfoDictionaryValue(@"CFBundleShortVersionString");
}

std::string GetOuterApplicationName() {
  return ApplicationInfoDictionaryValue(kCFBundleNameKey,
                                        OuterApplicationBundle());
}

std::string GetOuterApplicationVersion() {
  return ApplicationInfoDictionaryValue(@"CFBundleShortVersionString",
                                        OuterApplicationBundle());
}

}  // namespace electron
