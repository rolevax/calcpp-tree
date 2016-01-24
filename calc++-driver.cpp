#include "calc++-driver.h"

namespace calcxx_driver
{

void scan_begin(const std::string &filename, bool traceLex);
void scan_end();

RootAst *parse(const std::string& filename, bool traceLex, bool traceParse)
{
	RootAst *root = new RootAst;

	scan_begin(filename, traceLex); 
	yy::calcxx_parser parser(filename, root);
	parser.set_debug_level(traceParse);
	parser.parse(); 
	scan_end();

	return root;
}

}

