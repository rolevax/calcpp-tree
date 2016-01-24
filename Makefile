CXX=clang++ -std=c++11

all: parser lex
	${CXX} calc++.cpp calc++-driver.cpp calc++-parser.cc \
		calc++-scanner.cpp

parser:
	bison -o calc++-parser.cc calc++-parser.yy

lex:
	flex -o calc++-scanner.cpp calc++-scanner.ll 

clean:
	rm -rf a.out
	rm -rf calc++-parser.hh location.hh position.hh stack.hh calc++-parser.cc
	rm -rf calc++-scanner.cpp

