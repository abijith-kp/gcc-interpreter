#!/usr/bin/usr/python

import sys
import commands

def intro():
	print "\n A simple gcc compiler\n"

if __name__ == "__main__":
	intro()

	tmpFile = "tmpFile.c"   ## initially nothing will be there in the file
	arg = sys.argv

	if arg.__len__() == 2 and arg[1] == "-template":
		tmpFile = "tmpFileTemplate.c"    
		## initially a small template including stdio.h int main return statement will be there in the file

	while True:
		cmd = raw_input('gcc> ')
		
