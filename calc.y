%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
Symbol_Table symbol_table;

vector<Symbol*>* stack_machine;

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
        // cout << $1 << "; "  << endl;
      }
    | {}
		;

intermediate:
      VARIABLE ASSIGN exp { 
        $$ = $3; 
        // symbol_table.add(*$1, $3);
      }
    | exp { $$ = $1; }
    | {}
    ;

exp:		
		  exp PLUS term	{ 
        cout << "add " << endl;
        $$ = $1 + $3; 
      }
		| exp MINUS term	{ 
        cout << "sub " << endl;
        $$ = $1 - $3; 
      }
    | term          { $$ = $1; }
		;

term:
      term MULT final_state { 
        cout << "mul " << endl;
        $$ = $1 * $3; 
      }
    | term DIVIDE final_state {
        cout << "div " << endl;
        $$ = $1 / $3; 
      }
    | final_state { $$ = $1; }
    ;

final_state:
      VARIABLE {
      /* 
        if (symbol_table.is_variable_defined(*$1)) {
          // cout << "map contains " << *$1 << endl;
          $$ = symbol_table.get_value(*$1);
        } else {
          cout << "ERROR: " <<*$1 << " has not been initialized." << endl;
          exit(1);
        }
      */
        cout << "push variable" << *$1 << endl;
        $$ = 0;
        
        Symbol *new_symbol = new Symbol();
        new_symbol->set_name(*$1);
        stack_machine->push_back(new_symbol)
      }
    | INTEGER_LITERAL { 
        cout << "push const int" << $1 << endl;
        $$ = $1; 
    }
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


