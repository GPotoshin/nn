.PHONY: run

macos/linkmy.o: macos/Sources/port.m
	clang -c -o macos/linkmy.o macos/Sources/port.m

run:
	./zig-out/my.app/Contents/MacOS/nn

