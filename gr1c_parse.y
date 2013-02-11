/* gr1c -- Bison (and Yacc) grammar file
 *
 *
 * SCL; Jan-Feb, Sep 2012, Feb 2013.
 */


%{
  #include <stdlib.h>
  #include <stdio.h>
  #include "ptree.h"
  void yyerror( char const * );

  extern ptree_t *evar_list;
  extern ptree_t *svar_list;
  
  extern ptree_t *sys_init;
  extern ptree_t *env_init;

  extern ptree_t **env_goals;
  extern ptree_t **sys_goals;
  extern int num_egoals;
  extern int num_sgoals;

  extern ptree_t **env_trans_array;
  extern ptree_t **sys_trans_array;
  extern int et_array_len;
  extern int st_array_len;

  extern ptree_t *gen_tree_ptr;
%}

%error-verbose
/* %define api.pure */
%pure_parser
%locations


%union {
  char * str;
  int num;
}


%token E_VARS
%token S_VARS

%token E_INIT
%token E_TRANS
%token E_GOAL

%token S_INIT
%token S_TRANS
%token S_GOAL

%token COMMENT
%token <str> VARIABLE
%token <num> NUMBER
%token TRUE_CONSTANT
%token FALSE_CONSTANT

%left EQUIV
%left IMPLIES
%left SAFETY_OP
%left AND_SAFETY_OP
%left LIVENESS_OP
%left AND_LIVENESS_OP
%left EVENTUALLY_OP

%left '&' '|' '!' '=' '\''

%%

input: /* empty */
     | input exp
;

exp: evar_list ';'
   | svar_list ';'
   | E_INIT ';'
   | E_INIT propformula ';' {
         if (env_init != NULL)
             delete_tree( env_init );
         env_init = gen_tree_ptr;
         gen_tree_ptr = NULL;
     }
   | E_TRANS ';'
   | E_TRANS etransformula ';'
   | E_GOAL ';'
   | E_GOAL egoalformula ';'
   | S_INIT ';'
   | S_INIT propformula ';' {
         if (sys_init != NULL)
             delete_tree( sys_init );
         sys_init = gen_tree_ptr;
         gen_tree_ptr = NULL;
     }
   | S_TRANS ';'
   | S_TRANS stransformula ';'
   | S_GOAL ';'
   | S_GOAL sgoalformula ';'
   | error  { printf( "Error detected on line %d.\n", @1.last_line ); YYABORT; }
;

evar_list: E_VARS
         | evar_list VARIABLE  {
	       if (evar_list == NULL) {
		   evar_list = init_ptree( PT_VARIABLE, $2, 0 );
	       } else {
		   append_list_item( evar_list, PT_VARIABLE, $2, 0 );
	       }
           }
         | evar_list VARIABLE '[' NUMBER ',' NUMBER ']'  {
	       if (evar_list == NULL) {
		   evar_list = init_ptree( PT_VARIABLE, $2, $6 );
	       } else {
		   append_list_item( evar_list, PT_VARIABLE, $2, $6 );
	       }
           }
;

svar_list: S_VARS
         | svar_list VARIABLE  {
	       if (svar_list == NULL) {
		   svar_list = init_ptree( PT_VARIABLE, $2, 0 );
	       } else {
		   append_list_item( svar_list, PT_VARIABLE, $2, 0 );
	       }
           }
         | svar_list VARIABLE '[' NUMBER ',' NUMBER ']'  {
               if (svar_list == NULL) {
		   svar_list = init_ptree( PT_VARIABLE, $2, $6 );
	       } else {
		   append_list_item( svar_list, PT_VARIABLE, $2, $6 );
	       }
           }
;

etransformula: SAFETY_OP tpropformula  {
                   et_array_len++;
                   env_trans_array = realloc( env_trans_array, sizeof(ptree_t *)*et_array_len );
                   if (env_trans_array == NULL) {
                       perror( "gr1c_parse.y, etransformula, realloc" );
                       YYABORT;
                   }
                   *(env_trans_array+et_array_len-1) = gen_tree_ptr;
                   gen_tree_ptr = NULL;
               }
             | etransformula AND_SAFETY_OP tpropformula  {
                   et_array_len++;
                   env_trans_array = realloc( env_trans_array, sizeof(ptree_t *)*et_array_len );
                   if (env_trans_array == NULL) {
                       perror( "gr1c_parse.y, etransformula, realloc" );
                       YYABORT;
                   }
                   *(env_trans_array+et_array_len-1) = gen_tree_ptr;
                   gen_tree_ptr = NULL;
               }
;

stransformula: SAFETY_OP tpropformula  {
                   st_array_len++;
                   sys_trans_array = realloc( sys_trans_array, sizeof(ptree_t *)*st_array_len );
                   if (sys_trans_array == NULL) {
                       perror( "gr1c_parse.y, stransformula, realloc" );
                       YYABORT;
                   }
                   *(sys_trans_array+st_array_len-1) = gen_tree_ptr;
                   gen_tree_ptr = NULL;
               }
             | stransformula AND_SAFETY_OP tpropformula  {
                   st_array_len++;
                   sys_trans_array = realloc( sys_trans_array, sizeof(ptree_t *)*st_array_len );
                   if (sys_trans_array == NULL) {
                       perror( "gr1c_parse.y, stransformula, realloc" );
                       YYABORT;
                   }
                   *(sys_trans_array+st_array_len-1) = gen_tree_ptr;
                   gen_tree_ptr = NULL;
               }
;

egoalformula: LIVENESS_OP propformula  {
                  num_egoals++;
                  env_goals = realloc( env_goals, sizeof(ptree_t *)*num_egoals );
                  if (env_goals == NULL) {
                      perror( "gr1c_parse.y, egoalformula, realloc" );
                      YYABORT;
                  }
                  *(env_goals+num_egoals-1) = gen_tree_ptr;
                  gen_tree_ptr = NULL;
              }
            | egoalformula AND_LIVENESS_OP propformula  {
                  num_egoals++;
                  env_goals = realloc( env_goals, sizeof(ptree_t *)*num_egoals );
                  if (env_goals == NULL) {
                      perror( "gr1c_parse.y, egoalformula, realloc" );
                      YYABORT;
                  }
                  *(env_goals+num_egoals-1) = gen_tree_ptr;
                  gen_tree_ptr = NULL;
              }
;

sgoalformula: LIVENESS_OP propformula  {
                  num_sgoals++;
                  sys_goals = realloc( sys_goals, sizeof(ptree_t *)*num_sgoals );
                  if (sys_goals == NULL) {
                      perror( "gr1c_parse.y, sgoalformula, realloc" );
                      YYABORT;
                  }
                  *(sys_goals+num_sgoals-1) = gen_tree_ptr;
                  gen_tree_ptr = NULL;
              }
            | sgoalformula AND_LIVENESS_OP propformula  {
                  num_sgoals++;
                  sys_goals = realloc( sys_goals, sizeof(ptree_t *)*num_sgoals );
                  if (sys_goals == NULL) {
                      perror( "gr1c_parse.y, sgoalformula, realloc" );
                      YYABORT;
                  }
                  *(sys_goals+num_sgoals-1) = gen_tree_ptr;
                  gen_tree_ptr = NULL;
              }
;

propformula: TRUE_CONSTANT  {
                 gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_CONSTANT, NULL, 1 );
             }
           | FALSE_CONSTANT  {
                 gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_CONSTANT, NULL, 0 );
             }
           | VARIABLE  {
                 gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_VARIABLE, $1, 0 );
             }
           | '!' propformula  {
                 gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_NEG );
             }
           | propformula '&' propformula  {
                 gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_AND );
             }
           | propformula '|' propformula  {
                 gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_OR );
             }
           | propformula IMPLIES propformula  {
                 gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_IMPLIES );
             }
           | propformula EQUIV propformula  {
                 gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_EQUIV );
             }
           | VARIABLE '=' NUMBER  {
                 gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_VARIABLE, $1, 0 );
                 gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_CONSTANT, NULL, $3 );
                 gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_EQUALS );
             }
           | '(' propformula ')'
;

tpropformula: TRUE_CONSTANT  {
                  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_CONSTANT, NULL, 1 );
	      }
	    | FALSE_CONSTANT  {
		  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_CONSTANT, NULL, 0 );
	      }
	    | VARIABLE  {
		  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_VARIABLE, $1, 0 );
	      }
	    | VARIABLE '\''  {
		  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_NEXT_VARIABLE, $1, 0 );
	      }
	    | '!' tpropformula  {
		  gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_NEG );
	      }
	    | tpropformula '&' tpropformula  {
		  gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_AND );
	      }
	    | tpropformula '|' tpropformula  {
		  gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_OR );
	      }
	    | tpropformula IMPLIES tpropformula  {
		  gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_IMPLIES );
	      }
	    | tpropformula EQUIV tpropformula  {
		  gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_EQUIV );
	      }
	    | VARIABLE '=' NUMBER  {
		  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_VARIABLE, $1, 0 );
		  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_CONSTANT, NULL, $3 );
		  gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_EQUALS );
	      }
	    | VARIABLE '\'' '=' NUMBER  {
		  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_NEXT_VARIABLE, $1, 0 );
		  gen_tree_ptr = pusht_terminal( gen_tree_ptr, PT_CONSTANT, NULL, $4 );
		  gen_tree_ptr = pusht_operator( gen_tree_ptr, PT_EQUALS );
	      }
	    | '(' tpropformula ')'
;


%%

void yyerror( char const *s )
{
	fprintf( stderr, "%s\n", s );
}
