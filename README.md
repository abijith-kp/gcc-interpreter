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

  * History and in line editing support provided by rlwrap

Dependencies
============
  
  * rlwrap (readline wrapper need to be installed before using this tool)
        in Arch Linux: **pacman -S rlwrap**


To-Do
=====

  * Parsing functions individually
  
  * Getting inputs via scanf and all

  * Error in sed command call when the first input statement do not produce any output. The error comes from the second input statement onwards till any statement that gives an output is given as the input.

  * Prevent the program from generating output when no output statements are given as input
