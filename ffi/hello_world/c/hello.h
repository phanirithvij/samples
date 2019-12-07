// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#ifdef _WIN32
#define WINAPI __declspec(dllexport)
#else
#define WINAPI
#endif

WINAPI void hello_world();
