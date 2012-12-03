/* gr1c -- lexical analyzer (or "scanner")
 *
 * SCL; Jan-Feb, Aug 2012.
 */

%{
  #include "y.tab.h"
  #define YY_USER_ACTION yylloc->last_column += yyleng;
%}

%option bison-bridge bison-locations
%option noyywrap
%option warn nodefault


identifier  [a-zA-Z][a-zA-z0-9_\.]*
number  (-)?[0-9]+([.][0-9]+)?

%%

"&"[ \t]*"[]<>"  { return AND_LIVENESS_OP; }
"&"[ \t]*"[]"  { return AND_SAFETY_OP; }

"[]<>"  { return LIVENESS_OP; }
"[]"  { return SAFETY_OP; }
"<>" { return EVENTUALLY_OP; }

"->"  { return IMPLIES; }
[()&|!=';]  { return yytext[0]; }

\n  {
        yylloc->first_column = yylloc->last_column;
	yylloc->last_column = 0;
        yylloc->first_line = yylloc->last_line;
        ++(yylloc->last_line);
    }

"True"  { return TRUE_CONSTANT; }
"False"  { return FALSE_CONSTANT; }

^("ENV:")  { return E_VARS; }
^("SYS:")  { return S_VARS; }

^("ENVINIT:")  { return E_INIT; }
^("ENVTRANS:")  { return E_TRANS; }
^("ENVGOAL:")  { return E_GOAL; }

^("SYSINIT:")  { return S_INIT; }
^("SYSTRANS:")  { return S_TRANS; }
^("SYSGOAL:")  { return S_GOAL; }

{identifier}  { yylval->str = strdup( yytext ); return VARIABLE; }
{number}  { yylval->num = atoi( yytext ); return NUMBER; }

"#".*"\n"  { unput( '\n' ); }  /* Comments.
                                  unput is used to preserve line count. */

[ \t]+  {}  /* Ignore whitespace */

.  { return yytext[0]; }  /* Pass anything unknown to parser, as-is,
                             hence a syntax error. */