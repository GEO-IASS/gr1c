/** \file common.h
 * \brief Project-wide definitions and macros.
 *
 *
 * SCL; 2012, 2013.
 */


#ifndef COMMON_H
#define COMMON_H


#define GR1C_VERSION "0.5.8"
#define GR1C_COPYRIGHT "Copyright (c) 2012, 2013 by Scott C. Livingston,\nCalifornia Institute of Technology\nThis is free software, released under the GNU GPLv3 and without warranty."


#define GR1C_INTERACTIVE_PROMPT ">>> "


typedef int bool;
#define True 1
#define False 0

typedef unsigned char byte;


#include "util.h"
#include "cudd.h"

#endif