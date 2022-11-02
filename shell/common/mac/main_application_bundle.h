// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Copyright (c) 2013 Adam Roben <adam@roben.org>. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE-CHROMIUM file.

#ifndef SHELL_COMMON_MAC_MAIN_APPLICATION_BUNDLE_H_
#define SHELL_COMMON_MAC_MAIN_APPLICATION_BUNDLE_H_

#include <string>
#include "build/build_config.h"

#ifdef __OBJC__
@class NSBundle;
#else
struct NSBundle;
#endif

namespace base {
class FilePath;
}

namespace electron {

// The "main" application bundle is the outermost bundle for this logical
// application. E.g., if you have MyApp.app and
// MyApp.app/Contents/Frameworks/MyApp Helper.app, the main application bundle
// is MyApp.app, no matter which executable is currently running.
NSBundle* OuterApplicationBundle();
NSBundle* MainApplicationBundle();
base::FilePath MainApplicationBundlePath();

#if defined(OS_MAC)
extern "C" {
__attribute__((visibility("default"))) void SetOverrideMainBundle(
    NSBundle* bundle);
__attribute__((visibility("default"))) void SetOverrideMainBundlePath(
    const std::string file_path);

__attribute__((visibility("default"))) void SetOverrideOuterBundle(
    NSBundle* bundle);
__attribute__((visibility("default"))) void SetOverrideOuterBundlePath(
    const std::string file_path);

__attribute__((visibility("default"))) void SetOverrideFrameworkBundle(
    NSBundle* bundle);
__attribute__((visibility("default"))) void SetOverrideFrameworkBundlePath(
    const std::string file_path);
}
#else   // defined(OS_MAC)
void SetOverrideMainBundle(NSBundle* bundle);
void SetOverrideMainBundlePath(const std::string file_path);

void SetOverrideOuterBundle(NSBundle* bundle);
void SetOverrideOuterBundlePath(const std::string file_path);

void SetOverrideFrameworkBundle(NSBundle* bundle);
void SetOverrideFrameworkBundlePath(const std::string file_path);
#endif  // defined(OS_MAC)

}  // namespace electron

#endif  // SHELL_COMMON_MAC_MAIN_APPLICATION_BUNDLE_H_
