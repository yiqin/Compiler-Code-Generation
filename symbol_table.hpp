#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <string>
#include <map>

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