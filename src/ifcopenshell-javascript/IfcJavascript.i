/********************************************************************************
 *                                                                              *
 * This file is part of IfcOpenShell.                                           *
 *                                                                              *
 * IfcOpenShell is free software: you can redistribute it and/or modify         *
 * it under the terms of the Lesser GNU General Public License as published by  *
 * the Free Software Foundation, either version 3.0 of the License, or          *
 * (at your option) any later version.                                          *
 *                                                                              *
 * IfcOpenShell is distributed in the hope that it will be useful,              *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of               *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                 *
 * Lesser GNU General Public License for more details.                          *
 *                                                                              *
 * You should have received a copy of the Lesser GNU General Public License     *
 * along with this program. If not, see <http://www.gnu.org/licenses/>.         *
 *                                                                              *
 ********************************************************************************/

%begin %{
#if defined(_DEBUG) && defined(SWIG_PYTHON_INTERPRETER_NO_DEBUG)
/* https://github.com/swig/swig/issues/325 */
# include <basetsd.h>
# include <assert.h>
# include <ctype.h>
# include <errno.h>
# include <io.h>
# include <math.h>
# include <sal.h>
# include <stdarg.h>
# include <stddef.h>
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <sys/stat.h>
# include <time.h>
# include <wchar.h>
#endif

#include "boost/algorithm/string/case_conv.hpp"

#ifdef _MSC_VER
# pragma warning(push)
# pragma warning(disable : 4127 4244 4702 4510 4512 4610)
# if _MSC_VER > 1800
#  pragma warning(disable : 4456 4459)
# endif
#endif
// TODO add '# pragma warning(pop)' to the very end of the file
%}

%include "std_string.i"
%include "std_vector.i"
namespace std {
  %template(StringVector) vector<string>;
 }
%include "exception.i"


%exception {
	try {
		$action
	} catch(const IfcParse::IfcAttributeOutOfRangeException& e) {
		SWIG_exception(SWIG_IndexError, e.what());
	} catch(const IfcParse::IfcException& e) {
		SWIG_exception(SWIG_RuntimeError, e.what());
	} catch(const std::runtime_error& e) {
		SWIG_exception(SWIG_RuntimeError, e.what());
	} catch(...) {
		SWIG_exception(SWIG_RuntimeError, "An unknown error occurred");
	}
}

# %rename("by_type") entitiesByType;
%rename("objectType") type;

%module ifcopenshell_wrapper %{
	#include "../ifcparse/IfcFile.h"
	#include "../ifcparse/IfcLateBoundEntity.h"
%}

%extend IfcParse::IfcFile {
	IfcParse::IfcLateBoundEntity* by_id(unsigned id) {
		return (IfcParse::IfcLateBoundEntity*) $self->entityById(id);
	}
	IfcParse::IfcLateBoundEntity* by_guid(const std::string& guid) {
		return (IfcParse::IfcLateBoundEntity*) $self->entityByGuid(guid);
	}
 }


   //%include "../ifcparse/IfcFile.h"

%newobject open;
%inline %{
	IfcParse::IfcFile* open(const std::string& s) {
		IfcParse::IfcFile* f = new IfcParse::IfcFile(true);
		f->Init(s);
		return f;
	}

	const char* schema_identifier() {
		return IfcSchema::Identifier;
	}

	const char* version() {
		return IFCOPENSHELL_VERSION;
	}

	std::string get_supertype(std::string n) {
          	boost::to_upper(n);
		IfcSchema::Type::Enum t = IfcSchema::Type::FromString(n);
		if (IfcSchema::Type::Parent(t)) {
			return IfcSchema::Type::ToString(*IfcSchema::Type::Parent(t));
		} else {
			return "";
		}
        }

%}

%nodefaultctor IfcLateBoundEntity;


namespace IfcParse {
  /*
class IfcLateBoundEntity : public IfcUtil::IfcBaseEntity {
public:
  std::vector<std::string> getAttributeNames() const;
  std::vector<std::string> getInverseAttributeNames() const;
  Argument* getArgument(unsigned int i) const;
		bool is(IfcSchema::Type::Enum v) const;
		IfcSchema::Type::Enum type() const;	
		bool is_a(const std::string& s) const;
		std::string is_a() const;
		unsigned int id() const;
		unsigned int getArgumentCount() const;
		IfcUtil::ArgumentType getArgumentType(unsigned int i) const;
		IfcSchema::Type::Enum getArgumentEntity(unsigned int i) const;
};
  */
// not used %apply std::vector<std::string> OUTPUT {std::vector<std::string>* result};

class IfcFile {
public:
  // Identifier 'by_id' redefined by %extend (ignored),
  /* IfcLateBoundEntity* by_id(unsigned id);
   IfcLateBoundEntity* by_guid(const std::string& guid);
  */
        /*
	IfcParse::IfcLateBoundEntity* add(IfcParse::IfcLateBoundEntity* e) {
		return (IfcParse::IfcLateBoundEntity*) $self->addEntity(e);
	}

	void remove(IfcParse::IfcLateBoundEntity* e) {
		$self->removeEntity(e);
	}
	IfcEntityList::ptr traverse(IfcParse::IfcLateBoundEntity* e, int max_level=-1) {
		return $self->traverse(e, max_level);
	}
	IfcEntityList::ptr get_inverse(IfcParse::IfcLateBoundEntity* e) {
		return $self->getInverse(e->id(), IfcSchema::Type::UNDEFINED, -1);
	}

	void write(const std::string& fn) {
		std::ofstream f(fn.c_str());
		f << (*$self);
	}
	std::vector<unsigned> entity_names() const {
		std::vector<unsigned> keys;
		keys.reserve(std::distance($self->begin(), $self->end()));
		for (IfcParse::IfcFile::entity_by_id_t::const_iterator it = $self->begin(); it != $self->end(); ++ it) {
			keys.push_back(it->first);
		}
		return keys;
	}
        */
	/// Returns the first entity in the file, this probably is the entity
	/// with the lowest id (EXPRESS ENTITY_INSTANCE_NAME)
  //	const_iterator begin() const;
	/// Returns the last entity in the file, this probably is the entity
	/// with the highest id (EXPRESS ENTITY_INSTANCE_NAME)
  //	const_iterator end() const;
  /*
	/// Returns all entities in the file that match the template argument.
	/// NOTE: This also returns subtypes of the requested type, for example:
	/// IfcWall will also return IfcWallStandardCase entities
	template <class T>
	typename T::list::ptr entitiesByType() {
		IfcEntityList::ptr untyped_list = entitiesByType(T::Class());
		if (untyped_list) {
			return untyped_list->as<T>();
		} else {
			return typename T::list::ptr(new typename T::list);
		}
	}

	/// Returns all entities in the file that match the positional argument.
	/// NOTE: This also returns subtypes of the requested type, for example:
	/// IfcWall will also return IfcWallStandardCase entities
	IfcEntityList::ptr entitiesByType(IfcSchema::Type::Enum t);

	/// Returns all entities in the file that match the positional argument.
	/// NOTE: This also returns subtypes of the requested type, for example:
	/// IfcWall will also return IfcWallStandardCase entities
	IfcEntityList::ptr entitiesByType(const std::string& t);

	/// Returns all entities in the file that reference the id
	IfcEntityList::ptr entitiesByReference(int id);
  */
	/// Returns the entity with the specified id
	IfcUtil::IfcBaseClass* entityById(int id);
        /*
	/// Returns the entity with the specified GlobalId
	IfcSchema::IfcRoot* entityByGuid(const std::string& guid);

	/// Performs a depth-first traversal, returning all entity instance
	/// attributes as a flat list. NB: includes the root instance specified
	/// in the first function argument.
	IfcEntityList::ptr traverse(IfcUtil::IfcBaseClass* instance, int max_level=-1);

	bool Init(const std::string& fn);
	bool Init(std::istream& fn, int len);
	bool Init(void* data, int len);
	bool Init(IfcParse::IfcSpfStream* f);

	IfcEntityList::ptr getInverse(int instance_id, IfcSchema::Type::Enum type, int attribute_index);
        */
	unsigned int FreshId() { return ++MaxId; }
        /*
	IfcUtil::IfcBaseClass* addEntity(IfcUtil::IfcBaseClass* entity);
	void addEntities(IfcEntityList::ptr es);

	void removeEntity(IfcUtil::IfcBaseClass* entity);

	const IfcSpfHeader& header() const { return _header; }
	IfcSpfHeader& header() { return _header; }

	std::string createTimestamp() const;

	bool create_latebound_entities() const { return _create_latebound_entities; }

	std::pair<IfcSchema::IfcNamedUnit*, double> getUnit(IfcSchema::IfcUnitEnum::IfcUnitEnum);
        */
};
}


%rename($ignore, %$isclass) ""; // ignore all classes
%rename("%s") Argument; // Unignore 'Argument'

%rename("intValue") operator int;
%rename("stringValue") operator std::string;

#define IFC_PARSE_API
%include "../ifcparse/IfcUtil.h"

%rename("%s") IfcLateBoundEntity; // Unignore 'Argument IfcLateBoundEntity'
%include "../ifcparse/IfcLateBoundEntity.h"

 /*	virtual operator bool() const;
	virtual operator double() const;
	virtual operator std::string() const;
	virtual operator boost::dynamic_bitset<>() const;
	virtual operator IfcUtil::IfcBaseClass*() const;

	virtual operator std::vector<int>() const;
	virtual operator std::vector<double>() const;
	virtual operator std::vector<std::string>() const;
	virtual operator std::vector<boost::dynamic_bitset<> >() const;
	virtual operator IfcEntityList::ptr() const;

	virtual operator std::vector< std::vector<int> >() const;
	virtual operator std::vector< std::vector<double> >() const;
	virtual operator IfcEntityListList::ptr() const;

	virtual bool isNull() const = 0;
	virtual unsigned int size() const = 0;

	virtual IfcUtil::ArgumentType type() const = 0;
	virtual Argument* operator [] (unsigned int i) const = 0;
	virtual std::string toString(bool upper=false) const = 0;
 */
%extend IfcUtil::Argument {
   SwigV8ReturnValue getValue() {
  SWIGV8_HANDLESCOPE();
  
    v8::Handle<v8::Value> jsresult;
/*
  std::vector< std::string > *arg1 = (std::vector< std::string > *) 0 ;
  int arg2 ;
  void *argp1 = 0 ;
  int res1 = 0 ;
  int val2 ;
  int ecode2 = 0 ;
  std::vector< std::string >::value_type *result = 0 ;
  
  if(args.Length() != 1) SWIG_exception_fail(SWIG_ERROR, "Illegal number of arguments for _wrap_StringVector_get.");
  
  res1 = SWIG_ConvertPtr(args.Holder(), &argp1,SWIGTYPE_p_std__vectorT_std__string_t, 0 |  0 );
  if (!SWIG_IsOK(res1)) {
    SWIG_exception_fail(SWIG_ArgError(res1), "in method '" "StringVector_get" "', argument " "1"" of type '" "std::vector< std::string > *""'"); 
  }
  arg1 = (std::vector< std::string > *)(argp1);
  ecode2 = SWIG_AsVal_int(args[0], &val2);
  if (!SWIG_IsOK(ecode2)) {
    SWIG_exception_fail(SWIG_ArgError(ecode2), "in method '" "StringVector_get" "', argument " "2"" of type '" "int""'");
  } 
  arg2 = (int)(val2);
  try {
    result = (std::vector< std::string >::value_type *) &std_vector_Sl_std_string_Sg__get(arg1,arg2);
  }
  catch(std::out_of_range &_e) {
    SWIG_exception_fail(SWIG_IndexError, (&_e)->what());
  }
*/  
  jsresult = SWIG_From_std_string((std::string)"something");
  
  SWIGV8_RETURN(jsresult);
/*  
  goto fail;
fail:
  SWIGV8_RETURN(SWIGV8_UNDEFINED());
*/
}
}