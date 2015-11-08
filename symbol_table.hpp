#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <string>
#include <map>

enum class Type {
	INT,
	CONST_INT;
}

class Symbol
{
public:
	const std::string get_name() {
		return name;
	}
	const void set_name(std::string value) {
		name = value;
	}
	const Type get_type() {
		return type;
	}
	const void set_type(Type value) {
		type = value;
	}
	const std::string get_type_str() {
		if (type == Type::INT || typ == Type::CONST_INT) {
			return "int";
		} else {
			return "string";
		}
	}

	std::string code;
	
protected:
	std::string name;
	Type type;
};

class Symbol_Table
{
public:
	const void add (std::string key, int value) {
		m[key] = value;
	};
	const int get_value (std::string key) {
		return m[key];
	};
	const bool is_variable_defined (std::string key) {
		if (m.find(key) != m.end()) {
			return true;
		} else {
			return false;
		}
	};
protected:
	std::map<std::string, int> m;
};

#endif