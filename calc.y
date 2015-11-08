%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
Symbol_Table symbol_table;
%}


%union{
  int		int_val;
  string*	op_val;
}

%start	input 

%token	<int_val>	INTEGER_LITERAL
%token <op_val> VARIABLE

%type <op_val> input
%type <int_val> intermediate
%type	<int_val>	exp
%type <int_val> term
%type <int_val> final_state


%left	PLUS
%left MINUS
%left	MULT
%left DIVIDE
%left SEMICOLON
%left LEFT_PARENTHESIS
%left RIGHT_PARENTHESIS

%left ASSIGN

%%

input:
		| intermediate SEMICOLON input	{ 
        cout << $1 << "; "  << endl;
      }
    | {}
		;

intermediate:
      VARIABLE ASSIGN exp { 
        $$ = $3; 
        symbol_table.add(*$1, $3);
      }
    | exp { $$ = $1; }
    | {}
    ;

exp:		
		  exp PLUS exp	{ $$ = $1 + $3; }
		| exp MINUS exp	{ $$ = $1 - $3; }
    | term          { $$ = $1; }
		;

term:
      term MULT final_state { $$ = $1 * $3; }
    | term DIVIDE final_state { $$ = $1 / $3; }
    | final_state { $$ = $1; }
    ;

final_state:
      VARIABLE { 
        if (symbol_table.is_variable_defined(*$1)) {
          // cout << "map contains " << *$1 << endl;
          $$ = symbol_table.get_value(*$1);
        } else {
          cout << "ERROR: " <<*$1 << " has not been initialized." << endl;
          exit(1);
        }
      }
    | INTEGER_LITERAL { $$ = $1; }
    | LEFT_PARENTHESIS exp RIGHT_PARENTHESIS { $$ = $2; }
    ;

%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}


