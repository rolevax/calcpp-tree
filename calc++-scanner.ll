%{ /* C++ */
	#include <cerrno>
	#include <climits>
	#include <cstdlib>
	#include <string>
	#include "calc++-parser.hh"
	#include "lexproto.h"
	#include "parseexception.h"

	// Work around an incompatibility in flex (at least versions
	// 2.5.31 through 2.5.33): it generates code that does
	// not conform to C89.  See Debian bug 333231
	// <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=333231>.
	# undef yywrap
	# define yywrap() 1

	// The location of the current token.
	static yy::location loc;
%}

%option noyywrap nounput batch debug noinput

id    [a-zA-Z][a-zA-Z_0-9]*
int   [0-9]+
blank [ \t]

%{
	// Code run each time a pattern is matched.
	#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
	// Code run each time yylex is called.
	loc.step();
%}

{blank}+   loc.step();
[\n]+      loc.lines(yyleng); loc.step();
"-"      return yy::calcxx_parser::make_MINUS(loc);
"+"      return yy::calcxx_parser::make_PLUS(loc);
"*"      return yy::calcxx_parser::make_STAR(loc);
"/"      return yy::calcxx_parser::make_SLASH(loc);
"("      return yy::calcxx_parser::make_LPAREN(loc);
")"      return yy::calcxx_parser::make_RPAREN(loc);
":="     return yy::calcxx_parser::make_ASSIGN(loc);


{int}      {
	errno = 0;
	long n = strtol(yytext, NULL, 10);
	if (!(INT_MIN <= n && n <= INT_MAX && errno != ERANGE))
		throw ParseException(loc, "integer out of range");
	return yy::calcxx_parser::make_NUMBER(n, loc);
}

{id}       return yy::calcxx_parser::make_IDENTIFIER(yytext, loc);
.          throw ParseException(loc, "invalid character");
<<EOF>>    return yy::calcxx_parser::make_END(loc);

%%

namespace calcxx_driver
{ 

void scan_begin(const std::string &filename, bool traceLex)
{
	yy_flex_debug = traceLex;
	if (filename.empty() || filename == "-") {
		yyin = stdin;
	} else if (!(yyin = fopen(filename.c_str(), "r"))) {
		throw std::runtime_error("cannot open " + filename + ": " 
									+ strerror(errno));
	}
} 

void scan_end()
{
	fclose(yyin);
}

} // namespace calcxx_driver

