Gcc-interpreter
===============

  * Currently implemented as a bash script. Ideas of doing in python also. But not started.

  * There are two template files. One is empty file. Another one has a very simple template(.backup file). Every running of the interpreter will modify a copy of this file.

Features
========

  * Header files can be included at any point

  * Variables and functions can be declared

  * All variable and functions included will be defined inside the main function. 
    Something like the global scope will be defined inside the main function

To-Do
=====

  * Parsing functions individually

  * Prevent the program from generating output when on output statements are given as input.
