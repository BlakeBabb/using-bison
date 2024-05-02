%{
#include <string.h>
#include "hash.h"

struct hash* symbols = hash_create();

void yyerror(const char* err);

extern int yylex();
%}

/* %define api.value.type { char* } */

/* All nodes can be one of these types */
%union {
    char* str;
    float num;
}

/* types for terminals */
%token <str> IDENTIFIER
%token <num> NUMBER
%token <str> EQUALS PLUS MINUS TIMES DIVIDEDBY
%token <str> SEMICOLON LPAREN RPAREN

/* types for nonterminals */
%type <num> expression

/* set ascociativity and precedence */
%left PLUS MINUS
%left TIMES DIVIDEBY

/* top node of tree */
%start program

%%

program
    : program statement
    | statement
    ;

statement
    : IDENTIFIER EQUALS expression SEMICOLON {
        hash_insert(symbols, $1, $3);
        free($1);
    }
    ;

expression
    : LPAREN expression RPAREN { $$ = $2; }
    | expression PLUS expression { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression TIMES expression { $$ = $1 * $3; }
    | expression DIVIDEBY expression { $$ = $1 / $3; }
    | NUMBER { $$ = $1; }
    | IDENTIFIER {
        $$ = hash_get(symbols, $1);
        free($1);
    }
    ;

%%
