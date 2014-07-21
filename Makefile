build:
	clang -fobjc-arc -Wall -framework AppKit -framework ScriptingBridge -o youtube main.m
