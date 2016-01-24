#include <exception>
#include <string>
#include <sstream>
#include "location.hh"

class ParseException : public std::exception
{
public:
	ParseException(const yy::location &l, const std::string &m)
	{ 
		std::stringstream ss;
		ss << l << ": " << m << '\n';
		msg = ss.str();
	}

	const char *what() const noexcept override
	{
		return msg.c_str();
	}

private:
	std::string msg;
};

