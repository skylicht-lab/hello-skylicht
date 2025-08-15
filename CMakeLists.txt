cmake_minimum_required(VERSION 3.1)

# cmake config
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)

# cmake library
include(CMake/CMakeVisualStudioSourceGroup.cmake)
include(CMake/CMakeVisualStudioPCH.cmake)

# this line has to appear before 'PROJECT' in order to be able to disable incremental linking
set(MSVC_INCREMENTAL_DEFAULT ON)

# begin project
project(HELLO_SKYLICHT)
file(STRINGS "Version.txt" HELLO_SKYLICHT_VERSION)
message(STATUS "- App version ${HELLO_SKYLICHT_VERSION}")

# output
if (CMAKE_SYSTEM_NAME STREQUAL Android)
	set(LIBRARY_OUTPUT_PATH ${HELLO_SKYLICHT_SOURCE_DIR}/Bin/${CMAKE_SYSTEM_NAME}/Libs/${ANDROID_ABI} CACHE PATH "Single output directory for building all libraries.")
else()
	set(LIBRARY_OUTPUT_PATH ${HELLO_SKYLICHT_SOURCE_DIR}/Bin/${CMAKE_SYSTEM_NAME}/Libs CACHE PATH "Single output directory for building all libraries.")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${HELLO_SKYLICHT_SOURCE_DIR}/Bin CACHE PATH "Single output directory for building executables.")

# SKYLICHT SETUP
set(SKYLICHT_ENGINE_BIN_DIR ${HELLO_SKYLICHT_SOURCE_DIR}/Bin)
set(SKYLICHT_ENGINE_INSTALL_DIR "${HELLO_SKYLICHT_SOURCE_DIR}/../skylicht-engine/InstallLibs")
set(SKYLICHT_ENGINE_PROJECT_DIR "${SKYLICHT_ENGINE_INSTALL_DIR}/include")
set(SKYLICHT_ENGINE_DLL_PATH "${SKYLICHT_ENGINE_INSTALL_DIR}/bin/*.dll")

# for Editor
set(SKYLICHT_EDITOR_LOAD_BUNDLE ON)
set(SKYLICHT_EDITOR_INSTALL ON)
set(SKYLICHT_EDITOR_SOURCE_DIR ${HELLO_SKYLICHT_SOURCE_DIR}/Source)
set(SKYLICHT_EDITOR_ROOT_DIR ${HELLO_SKYLICHT_SOURCE_DIR})

set(SKYLICHT_VERSION ${HELLO_SKYLICHT_VERSION})

# debug/release
if (NOT CMAKE_BUILD_TYPE)
	# set(CMAKE_BUILD_TYPE "Debug")
	set(CMAKE_BUILD_TYPE "Release")
endif()

message(STATUS "- System: ${CMAKE_SYSTEM_NAME} - BuildType: ${CMAKE_BUILD_TYPE}")

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG")
endif()

set(CMAKE_CXX_STANDARD 17)

option(BUILD_SHARED_LIBS "Use shared libraries" OFF)

option(USE_MSVC_RUNTIME_LIBRARY_DLL "Use MSVC Runtime Library DLL (/MD or /MDd)" ON)

# unicode library
add_definitions(-DUNICODE -D_UNICODE)

# visual studio
if (MSVC)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
	
	if (NOT USE_MSVC_RUNTIME_LIBRARY_DLL)
		#We statically link to reduce dependancies
		foreach(flag_var CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)
			if (${flag_var} MATCHES "/MD")
				string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
			endif (${flag_var} MATCHES "/MD")
			if (${flag_var} MATCHES "/MDd")
				string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
			endif (${flag_var} MATCHES "/MDd")
		endforeach()
	endif()	
	
	if (CMAKE_CL_64)
		add_definitions(-D_WIN64)
	endif()

	set(CMAKE_EXE_LINKER_FLAGS	"${CMAKE_EXE_LINKER_FLAGS} /MANIFEST:NO")
endif()

include(SkylichtLibrary.cmake)

subdirs(Source/HelloWorld)
subdirs(Source/Physics)

# you can copy Editor source to here
# subdirs(Source/Editor)

# unit test
if (NOT BUILD_ANDROID AND NOT BUILD_IOS AND NOT BUILD_EMSCRIPTEN AND NOT BUILD_WINDOWS_STORE)
enable_testing()
subdirs (UnitTest/TestApp)
endif()