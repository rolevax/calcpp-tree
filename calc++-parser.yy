%skeleton "lalr1.cc" /*  C++  */
%require "3.0.4"

%defines
%define parser_class_name {calcxx_parser}
%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires
{
	#include <string>
	#include "ast.h"
	class ParseException;
}

// The parsing context.
%param { const std::string &filename }
%param { RootAst *result }

%locations
%initial-action
{
	// Initialize the initial location.

	// position.filename is a non-const pointer somehow
	static std::string s_filename(filename);
	@$.begin.filename = @$.end.filename = &s_filename;
};
%define parse.trace
%define parse.error verbose

%code
{
	#include "lexproto.h"
	#include "parseexception.h"
}

%define api.token.prefix {TOK_}

%token
  END  0  "EOF"
  ASSIGN  ":="
  MINUS   "-"
  PLUS    "+"
  STAR    "*"
  SLASH   "/"
  LPAREN  "("
  RPAREN  ")"
;
%token <std::string> IDENTIFIER "identifier"
%token <int> NUMBER "number"
%type  <Ast*> assignment
%type  <Ast*> exp
%printer { yyoutput << $$; } <*>;

%% /* rules */

%start unit;

unit:
  assignments exp { result->add($2); };

assignments:
  %empty                 {}
| assignments assignment { result->add($2); };

assignment:
  "identifier" ":=" exp { $$ = new BinOpAst(Ast::Type::ASS, 
											new VarAst($1), $3); };

%left "+" "-";
%left "*" "/";
exp:
  exp "+" exp   { $$ = new BinOpAst(Ast::Type::ADD, $1, $3); }
| exp "-" exp   { $$ = new BinOpAst(Ast::Type::SUB, $1, $3); }
| exp "*" exp   { $$ = new BinOpAst(Ast::Type::MUL, $1, $3); }
| exp "/" exp   { $$ = new BinOpAst(Ast::Type::DIV, $1, $3); }
| "(" exp ")"   { $$ = $2; }
| "identifier"  { $$ = new VarAst($1); }
| "number"      { $$ = new NumAst($1); };

%%

void yy::calcxx_parser::error(const location_type& l,
                              const std::string& m)
{
	throw ParseException(l, m);
}

