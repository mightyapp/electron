// Copyright (c) 2013 GitHub, Inc.
// Use of this source code is governed by the MIT license that can be
// found in the LICENSE file.

#ifndef SHELL_COMMON_PLATFORM_UTIL_H_
#define SHELL_COMMON_PLATFORM_UTIL_H_

#include <string>

#include "base/callback_forward.h"
#include "base/files/file_path.h"
#include "build/build_config.h"
#include "ui/gfx/native_widget_types.h"

class GURL;

namespace platform_util {

typedef base::OnceCallback<void(const std::string&)> OpenCallback;

// Show the given file in a file manager. If possible, select the file.
// Must be called from the UI thread.
void ShowItemInFolder(const base::FilePath& full_path);

// Open the given file in the desktop's default manner.
// Must be called from the UI thread.
void OpenPath(const base::FilePath& full_path, OpenCallback callback);

struct OpenExternalOptions {
  bool activate = true;
  base::FilePath working_dir;
};

// Open the given external protocol URL in the desktop's default manner.
// (For example, mailto: URLs in the default mail user agent.)
void OpenExternal(const GURL& url,
                  const OpenExternalOptions& options,
                  OpenCallback callback);

// Move a file to trash, asynchronously.
void TrashItem(const base::FilePath& full_path,
               base::OnceCallback<void(bool, const std::string&)> callback);

void Beep();

// Returns a NativeView handle for parenting dialogs off |window|. This can be
// used to position a dialog using a NativeWindow, when a NativeView (e.g.
// browser tab) isn't available.
gfx::NativeView GetViewForWindow(gfx::NativeWindow window);

// Returns true if the view is visible. The exact definition of this is
// platform-specific, but it is generally not "visible to the user", rather
// whether the view has the visible attribute set.
bool IsVisible(gfx::NativeView view);

#if defined(OS_WIN)
// SHGetFolderPath calls not covered by Chromium
bool GetFolderPath(int key, base::FilePath* result);
#endif

#if defined(OS_MAC)
bool GetLoginItemEnabled();
bool SetLoginItemEnabled(bool enabled);
#endif

#if defined(OS_LINUX)
// Returns a success flag.
// Unlike libgtkui, does *not* use "chromium-browser.desktop" as a fallback.
bool GetDesktopName(std::string* setme);
#endif

}  // namespace platform_util

#endif  // SHELL_COMMON_PLATFORM_UTIL_H_
