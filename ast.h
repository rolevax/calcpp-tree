#include <string>
#include <memory>
#include <vector>
#include <iostream>

class Ast 
{
public:
	enum class Type
	{
		ROOT, ADD, SUB, MUL, DIV, ASS, VAR, NUM
	};

	Ast(Type type) : type(type) {}
	Ast(const Ast& copy) = delete;
	Ast &operator=(const Ast& assign) = delete;
	virtual ~Ast() = default;

	Type getType() const { return type; }
	virtual void dump() const = 0;

private:
	Type type;
};

class VarAst : public Ast
{
public:
	VarAst(const std::string &id) : Ast(Ast::Type::VAR), id(id) {}

	void dump() const override
	{
		std::cout << id << ' ';
	}

private:
	std::string id;
};

class NumAst : public Ast
{
public:
	NumAst(int val) : Ast(Ast::Type::NUM), val(val) {}

	void dump() const override
	{
		std::cout << val << ' ';
	}

private:
	int val;
};

class BinOpAst : public Ast
{
public:
	BinOpAst(Ast::Type type, Ast *left, Ast *right) 
		: Ast(type), left(left), right(right) {}

	void dump() const override
	{
		std::cout << operador() << ' ';
		left->dump();
		right->dump();
	}

private: 
	const char *operador() const
	{
		switch (getType()) {
			case Ast::Type::ADD:
				return "+";
			case Ast::Type::SUB:
				return "-";
			case Ast::Type::MUL:
				return "*";
			case Ast::Type::DIV:
				return "/";
			case Ast::Type::ASS:
				return ":=";
			default:
				return "WTF";
		}
	}

	std::unique_ptr<Ast> left;
	std::unique_ptr<Ast> right;
};

class RootAst : public Ast
{
public:
	RootAst() : Ast(Ast::Type::ROOT) {}

	void dump() const override
	{
		for (const auto &t : subtrees) {
			t->dump();
			std::cout << std::endl;
		}
	}

	void add(Ast *subtree)
	{
		subtrees.emplace_back(subtree);
	}

private:
	std::vector<std::unique_ptr<Ast>> subtrees;
};

