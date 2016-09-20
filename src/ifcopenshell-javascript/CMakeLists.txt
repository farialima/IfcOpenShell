################################################################################
#                                                                              #
# This file is part of IfcOpenShell.                                           #
#                                                                              #
# IfcOpenShell is free software: you can redistribute it and/or modify         #
# it under the terms of the Lesser GNU General Public License as published by  #
# the Free Software Foundation, either version 3.0 of the License, or          #
# (at your option) any later version.                                          #
#                                                                              #
# IfcOpenShell is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                 #
# Lesser GNU General Public License for more details.                          #
#                                                                              #
# You should have received a copy of the Lesser GNU General Public License     #
# along with this program. If not, see <http://www.gnu.org/licenses/>.         #
#                                                                              #
################################################################################

FIND_PACKAGE(SWIG)
IF(NOT SWIG_FOUND)
	MESSAGE(FATAL_ERROR "unable to find SWIG, cannot build Javascript interface.")
ENDIF()

#IF(NOT EXISTS ${NODE_ROOT_DIR})
#	MESSAGE(FATAL_ERROR "Unable to find Node.js at location NODE_ROOT_DIR=${NODE_ROOT_DIR}, cannot build Javascript interface.")
#ENDIF()

INCLUDE(${SWIG_USE_FILE})

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

SET(CMAKE_SWIG_FLAGS "")

SET(CMAKE_CXX_FLAGS "-std=c++11 -fPIC -fvisibility=hidden -fvisibility-inlines-hidden -mmacosx-version-min=10.6") 
SET(CMAKE_C_FLAGS "-std=c++11 -fPIC -fvisibility=hidden -fvisibility-inlines-hidden -mmacosx-version-min=10.6") 
add_definitions(-std=c++11 -fPIC -fvisibility=hidden -fvisibility-inlines-hidden -mmacosx-version-min=10.7) 

SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")
find_path (NODE_ROOT_DIR "include/node/node.h")
    set (NODE_INCLUDE_DIRS
      ${NODE_ROOT_DIR}/include/src
      ${NODE_ROOT_DIR}/include/node
      ${NODE_ROOT_DIR}/include/deps/v8/include
      ${NODE_ROOT_DIR}/include/deps/uv/include
    )

include_directories ( 
      "${NODE_INCLUDE_DIRS}"
    )

SET_SOURCE_FILES_PROPERTIES(IfcJavascript.i PROPERTIES CPLUSPLUS ON)
set_property (SOURCE IfcJavascript.i PROPERTY SWIG_FLAGS "-node") # TODO "-DV8_VERSION=${V8_VERSION_HEX}")
SWIG_ADD_MODULE(ifcopenshell_wrapper javascript IfcJavascript.i)
SWIG_LINK_LIBRARIES(ifcopenshell_wrapper ${IFCOPENSHELL_LIBRARIES} ${OPENCASCADE_LIBRARIES} ${ICU_LIBRARIES})

# Not tested on Win32 yet...
if (NOT WIN32)
    SET_INSTALL_RPATHS(${SWIG_MODULE_ifcopenshell_wrapper_REAL_NAME} "${IFCDIRS};${OCC_LIBRARY_DIR};${ICU_LIBRARY_DIR}")
endif()

set_target_properties (ifcopenshell_wrapper PROPERTIES
      COMPILE_FLAGS "${CMAKE_CXX_FLAGS} -DBUILDING_NODE_EXTENSION -DSWIG_V8_VERSION=0x032873"
      PREFIX ""
      SUFFIX ".node"
    )

# Install not implemented/tested yet...
# INSTALL(TARGETS ifcopenshell_wrapper DESTINATION "TDB/ifcopenshell")


