/* ptree.h -- Routines for working with a GR(1) formula parse tree.
 *
 * To avoid defining another basic data structure, we may effectively
 * obtain a linked list by making a binary tree with no right children
 * (or more generally, a tree in which each node has at most one
 * child).  Functions intended specifically to support this use case
 * include "list" in their names.
 *
 * For functions concerning tree nodes, any arguments that are not
 * applicable to the given type are ignored.
 *
 *
 * SCL; Jan, Feb 2012.
 */


#ifndef _PTREE_H_
#define _PTREE_H_


/********************
 **** Node types ****/
/* variables or constant */
#define PT_EMPTY 0
#define PT_VARIABLE 1
#define PT_NEXT_VARIABLE 2
#define PT_CONSTANT 3

/* unary */
#define PT_NEG 4

/* binary */
#define PT_AND 5
#define PT_OR 6
#define PT_IMPLIES 7
#define PT_EQUALS 8
/********************/

typedef struct ptree_t
{
	int type;  /* See table above for recognized types. */
	char *name;  /* Name of the variable, if applicable. */
	int value;  /* Value of a constant.  If of type boolean, then 0
				   means "false", and 1 "true". */
	
	struct ptree_t *left;
	struct ptree_t *right;
} ptree_t;


ptree_t *init_ptree( int type, char *name, int value );
/* Create root node with given type.  Return NULL on error. */

int tree_size( ptree_t *head );
/* Return number of nodes in tree. */

void print_node( ptree_t *node, FILE *f );
/* If f is NULL, then use stdout. */

void inorder_trav( ptree_t *head,
				   void (* node_fn)(ptree_t *, void *), void *arg );
/* Traverse the tree in-order, calling *node_fn at each node and
   passing it arg. */

int tree_dot_dump( ptree_t *head, char *filename );
/* Generate Graphviz DOT file depicting the parse tree.  Return 0 on
   success, -1 on error. */

void delete_tree( ptree_t *head );
/* Delete tree with given root node. */

ptree_t *pusht_terminal( ptree_t *head, int type, char *name, int value );
/* Push variable or constant into top of tree.  (Behavior is
   like reverse Polish notation.)  Return the new head, or NULL on
   error. */

ptree_t *pusht_operator( ptree_t *head, int type );
/* Push unary binary operator into top of tree.  (Behavior is like reverse
   Polish notation.)  Return the new head, or NULL on error. */

ptree_t *append_list_item( ptree_t *head, int type, char *name, int value );
/* Return pointer to new item (which is of course accessible via given
   root node).  If argument head is NULL, then behave exactly as
   init_ptree (and thus, a new tree root node is returned). */

ptree_t *remove_list_item( ptree_t *head, int index );
/* 0-based indexing.  An index of -1 refers to the last item in the
   list.  Return pointer to parent of removed node if non-root, or to
   item with original index of 1 if root.

   If head is NULL (i.e., tree is empty), then print a warning and
   return NULL.  If index is outside of possible range, then print
   warning and return NULL. */


#endif
