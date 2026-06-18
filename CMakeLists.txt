cmake_minimum_required(VERSION 3.10)

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
list(GET HELLO_SKYLICHT_VERSION 0 APP_VERSION)
list(GET HELLO_SKYLICHT_VERSION 1 APP_VERSION_CODE)

message(STATUS "- App version ${APP_VERSION}")
message(STATUS "- App version code ${APP_VERSION_CODE}")

add_definitions(-DAPP_VERSION="${APP_VERSION}")
add_definitions(-DAPP_VERSION_CODE=${APP_VERSION_CODE})

set (SKYLICHT_VERSION APP_VERSION)

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

set(SKYLICHT_VERSION ${APP_VERSION})

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG")
endif()

set(CMAKE_CXX_STANDARD 17)

option(BUILD_SHARED_LIBS "Use shared libraries" OFF)

option(USE_MSVC_RUNTIME_LIBRARY_DLL "Use MSVC Runtime Library DLL (/MD or /MDd)" ON)

option(USE_PRECISE_FLOATINGPOINT "Use precise floating point math for synchronization" OFF)

# unicode library
add_definitions(-DUNICODE -D_UNICODE)

if (BUILD_SHARED_LIBS)
	message(STATUS "Use dynamic libs")
	set(ENGINE_SHARED_OR_STATIC_LIB "SHARED")
else()
	message(STATUS "Use static libs")
	set(ENGINE_SHARED_OR_STATIC_LIB "STATIC")
endif()

if (MSVC)
	# Select the MSVC CRT via CMake's runtime abstraction:
	# ON  => /MD,  /MDd
	# OFF => /MT,  /MTd
	if (USE_MSVC_RUNTIME_LIBRARY_DLL)
		set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
	else()
		set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
		if (BUILD_SHARED_LIBS)
		add_definitions(-DUSE_SHARED_HEAP_MEMORY)
		endif()
	endif()
endif()

# visual studio
if (MSVC)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
	
	if (CMAKE_CL_64)
		add_definitions(-D_WIN64)
	endif()

	set(CMAKE_EXE_LINKER_FLAGS	"${CMAKE_EXE_LINKER_FLAGS} /MANIFEST:NO")
	
	if (USE_PRECISE_FLOATINGPOINT)
		add_compile_options(/fp:precise)
	else()
		add_compile_options(/fp:fast)
	endif()
else()
	# other compilers (Linux, MacOS, ...)
	if (USE_PRECISE_FLOATINGPOINT)
		add_compile_options(-fno-fast-math)
		if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
			add_compile_options(-fexcess-precision=standard)
		elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
			add_compile_options(-ffp-model=precise)
		endif()
	endif()
endif()

include(SkylichtLibrary.cmake)

if (BUILD_MACOS)
set(SKYLICHT_EDITOR_INSTALL OFF)
endif()

if (BUILD_EDITOR_TOOL)
# you can copy Editor source to here
# Replace CMakeLists.txt with CShared.txt
subdirs(Source/Editor)
endif()

subdirs(Source/HelloWorld)
subdirs(Source/Physics)

# unit test
if (NOT BUILD_ANDROID AND NOT BUILD_IOS AND NOT BUILD_EMSCRIPTEN AND NOT BUILD_WINDOWS_STORE)
enable_testing()
subdirs (UnitTest/TestApp)
endif()