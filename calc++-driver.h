#ifndef CALCXX_DRIVER_HH
# define CALCXX_DRIVER_HH
#include "calc++-parser.hh"

# include <string>

class Ast;

namespace calcxx_driver
{
RootAst *parse(const std::string& f, bool traceLex = false, 
									 bool traceParse = false);

};
#endif // ! CALCXX_DRIVER_HH

