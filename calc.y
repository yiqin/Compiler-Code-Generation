%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
Symbol_Table symbol_table;

vector<Symbol*> stack_machine;
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
        symbol_table.add(*$1, $3);
        stack_machine.pop_back();
        cout << "assign variable " << *$1 << " with " << $3 << endl;
      }
    | exp { $$ = $1; }
    | {}
    ;

exp:		
		  exp PLUS term	{ 
        cout << "add " << endl;
        $$ = $1 + $3;

        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);

        int int_value_result = symbol_1->get_int_value() + symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);
      }
		| exp MINUS term	{ 
        cout << "sub " << endl;
        $$ = $1 - $3; 

        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);
        
        int int_value_result = symbol_1->get_int_value() - symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);
      }
    | term          { $$ = $1; }
		;

term:
      term MULT final_state { 
        cout << "mul " << endl;
        $$ = $1 * $3; 

        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);
        
        int int_value_result = symbol_1->get_int_value() * symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);
      }
    | term DIVIDE final_state {
        cout << "div " << endl;
        $$ = $1 / $3; 

        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);
        
        int int_value_result = symbol_1->get_int_value() / symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);
      }
    | final_state { $$ = $1; }
    ;

final_state:
      VARIABLE {
        cout << "push variable " << *$1 << endl;
        $$ = 0;

        // Push it to the stack machine ??
        Symbol *new_symbol = new Symbol();
        new_symbol->set_type(Type::INT);
        new_symbol->set_name(*$1);

        // set int value
        if (symbol_table.is_variable_defined(*$1)) {
          new_symbol->set_int_value(symbol_table.get_value(*$1));
          stack_machine.push_back(new_symbol);

        } else {
          cout << "ERROR: " <<*$1 << " has not been initialized." << endl;
          // exit(1);
        }
        
      }
    | INTEGER_LITERAL { 
        cout << "push const int " << $1 << endl;
        $$ = $1; 

        // Push it to the stack machine ??
        Symbol *new_symbol = new Symbol();
        new_symbol->set_type(Type::CONST_INT);
        new_symbol->set_int_value($1);

        stack_machine.push_back(new_symbol);
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


