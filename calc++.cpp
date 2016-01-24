#include "calc++-driver.h" 
#include <iostream>

int main(int argc, char *argv[])
{
	bool traceLex= false;
	bool traceParse = false;

	for (int i = 1; i < argc; i++) {
		if (argv[i][0] == '-' && argv[i][1] == 'p') {
			traceParse = true;
		} else if (argv[i][0] == '-' && argv[i][1] == 's') {
			traceLex = true;
		} else {
			using namespace calcxx_driver;
			try {
				RootAst *root = parse(argv[i], traceLex, traceParse);
				std::cout << "Pre-order dump:" << std::endl;
				root->dump();
			} catch (std::exception &e) {
				std::cout << e.what() << std::endl;
			}
		}
	}

	return 0;
}

