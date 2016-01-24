#ifndef LEXPROTO_H
#define LEXPROTO_H

// Tell Flex the lexer's prototype ...
#define YY_DECL \
 yy::calcxx_parser::symbol_type yylex(const std::string& filename, \
		                              RootAst *result)
// ... and declare it for the parser's sake.
YY_DECL;

#endif

