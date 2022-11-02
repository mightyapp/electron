// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Copyright (c) 2013 Adam Roben <adam@roben.org>. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE-CHROMIUM file.

#import "shell/common/mac/main_application_bundle.h"

#include "base/files/file_path.h"
#include "base/mac/bundle_locations.h"
#include "base/mac/foundation_util.h"
#include "base/path_service.h"
#include "base/strings/string_util.h"
#include "base/strings/sys_string_conversions.h"
#include "content/common/mac_helpers.h"
#include "ppapi/buildflags/buildflags.h"

namespace electron {

namespace {

bool HasMainProcessKey() {
  NSDictionary* info_dictionary = [base::mac::MainBundle() infoDictionary];
  return
      [[info_dictionary objectForKey:@"ElectronMainProcess"] boolValue] != NO;
}

}  // namespace

// NSBundle isn't threadsafe, all functions in this file must be called on the
// main thread.
static NSBundle* g_override_main_bundle = nil;
static NSBundle* g_override_outer_bundle = nil;
static NSBundle* g_override_framework_bundle = nil;

static void AssignOverrideBundle(NSBundle* new_bundle,
                                 NSBundle** override_bundle) {
  if (new_bundle != *override_bundle) {
    [*override_bundle release];
    *override_bundle = [new_bundle retain];
  }
}

static void AssignOverridePath(const base::FilePath& file_path,
                               NSBundle** override_bundle) {
  NSString* path = base::SysUTF8ToNSString(file_path.value());
  NSBundle* new_bundle = [NSBundle bundleWithPath:path];
  DCHECK(new_bundle) << "Failed to load the bundle at " << file_path.value();
  AssignOverrideBundle(new_bundle, override_bundle);
}

void SetOverrideMainBundle(NSBundle* bundle) {
  AssignOverrideBundle(bundle, &g_override_main_bundle);
}

void SetOverrideMainBundlePath(const std::string file_path) {
  base::FilePath path(file_path);
  AssignOverridePath(path, &g_override_main_bundle);
}

void SetOverrideFrameworkBundle(NSBundle* bundle) {
  base::mac::SetOverrideFrameworkBundle(bundle);
  AssignOverrideBundle(bundle, &g_override_framework_bundle);
}

void SetOverrideFrameworkBundlePath(const std::string file_path) {
  base::FilePath path(file_path);
  base::mac::SetOverrideFrameworkBundlePath(path);
  AssignOverridePath(path, &g_override_framework_bundle);
}

void SetOverrideOuterBundle(NSBundle* bundle) {
  base::mac::SetOverrideOuterBundle(bundle);
  AssignOverrideBundle(bundle, &g_override_outer_bundle);
}

void SetOverrideOuterBundlePath(const std::string file_path) {
  base::FilePath path(file_path);
  base::mac::SetOverrideOuterBundlePath(path);
  AssignOverridePath(path, &g_override_outer_bundle);
}

base::FilePath MainApplicationBundlePath() {
  if (g_override_outer_bundle) {
    return base::mac::NSStringToFilePath([g_override_outer_bundle bundlePath]);
  }

  // Start out with the path to the running executable.
  base::FilePath path;
  base::PathService::Get(base::FILE_EXE, &path);

  // Up to Contents.
  if (!HasMainProcessKey() &&
      (base::EndsWith(path.value(), " Helper", base::CompareCase::SENSITIVE) ||
#if BUILDFLAG(ENABLE_PLUGINS)
       base::EndsWith(path.value(), content::kMacHelperSuffix_plugin,
                      base::CompareCase::SENSITIVE) ||
#endif
       base::EndsWith(path.value(), content::kMacHelperSuffix_renderer,
                      base::CompareCase::SENSITIVE) ||
       base::EndsWith(path.value(), content::kMacHelperSuffix_gpu,
                      base::CompareCase::SENSITIVE))) {
    // The running executable is the helper. Go up five steps:
    // Contents/Frameworks/Helper.app/Contents/MacOS/Helper
    // ^ to here                                     ^ from here
    path = path.DirName().DirName().DirName().DirName().DirName();
  } else {
    // One step up to MacOS, another to Contents.
    path = path.DirName().DirName();
  }
  DCHECK_EQ(path.BaseName().value(), "Contents");

  // Up one more level to the .app.
  path = path.DirName();
  DCHECK_EQ(path.BaseName().Extension(), ".app");

  return path;
}

NSBundle* MainApplicationBundle() {
  if (g_override_main_bundle) {
    return g_override_main_bundle;
  }

  return [NSBundle bundleWithPath:base::mac::FilePathToNSString(
                                      MainApplicationBundlePath())];
}

NSBundle* OuterApplicationBundle() {
  if (g_override_outer_bundle) {
    return g_override_outer_bundle;
  }

  return MainApplicationBundle();
}

base::FilePath OuterApplicationBundlePath() {
  return base::mac::NSStringToFilePath([OuterApplicationBundle() bundlePath]);
}

}  // namespace electron
