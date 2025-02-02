.PHONY: names

macos/linkmy.o: macos/Sources/root.swift
	swiftc -c -parse-as-library -o macos/linkmy.o macos/Sources/root.swift

names:
	install_name_tool -change /usr/lib/swift/libswift_errno.dylib @rpath/libswift_errno.dylib zig-out/my.app/Contents/MacOS/nn
