# PString Exercise Project:  
1. [Introduction](#introduction)  
2. [main.s:](#main.s)  
3. [Dependencies:](#dependencies)  


## Introduction
An exercise in computer structure course, we were given a task to implement several methods similar to the string.h, as-

1. char pstrlen(Pstring* pstr) - get the length of pstring.
2. Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar) - replace all the oldChar with new char in pstring
3. Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j) - copy src[i:j] to dst[i:j]
4. Pstring* swapCase(Pstring* pstr) - replace from lower case to upper case and the opposite.
5. int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j) - compare between src[i:j] to dst[i:j]

## main.s:
Getting an int from the user- length of the first "pstring" (n1),
then getting n1 chars (without "\n") for the first pstirng.
Than doing the same procces for the 2nd pstring.
getting a number from the user (50-55) and run one of the functions above using switch case.

## Dependencies:
* MacOS / Linux
* Git
