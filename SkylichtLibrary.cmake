# Target of install library from https://github.com/skylicht-lab/skylicht-engine
# skylicht-engine\BuildCommand\InstallLibVCPrj2022.cmd
set(SKYLICHT_TARGETS_DIR "./InstallLibs/cmake")

option(USE_SKYLICHT_SHARED_LIBS "Use skylicht shared libraries" OFF)
option(USE_SKYLICHT_NETWORK "Use skylicht network libraries" ON)
option(USE_SKYLICHT_IMGUI "Use imgui libraries" ON)
option(USE_BULLET_PHYSIC_ENGINE "Use bullet physics engine" ON)
option(USE_OPENMP "Use openmp for multithread optimize" ON)

include(PlatformConfig.cmake)

if (NOT USE_SKYLICHT_SHARED_LIBS)
	add_definitions(-D_IRR_STATIC_LIB_)
	add_definitions(-D_SKYLICHT_STATIC_LIB_)
endif()

if (USE_BULLET_PHYSIC_ENGINE)
	add_definitions(-DUSE_BULLET_PHYSIC_ENGINE)
endif()

if (USE_OPENMP)
	if (CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
		# AppleClang
		find_package(OpenMP REQUIRED)
		if (OPENMP_FOUND)
			set(OpenMP_C_FLAGS "-Xpreprocessor -fopenmp")
			set(OpenMP_CXX_FLAGS "-Xpreprocessor -fopenmp")
			
			set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
			set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
			
			find_file(OMP_H_PATH NAME omp.h HINTS OpenMP)
			get_filename_component(OMP_INCLUDE_DIR ${OMP_H_PATH} DIRECTORY)
			include_directories(${OMP_INCLUDE_DIR})
			
			find_library(OMP_LIBRARY NAMES omp)
			link_libraries(${OMP_LIBRARY})
			
			message(STATUS "- OpenMP library found: ${OMP_H_PATH}")
			message(STATUS "- OpenMP include directory: ${OMP_INCLUDE_DIR}")
			message(STATUS "- OpenMP link directory: ${OMP_LIBRARY}")
			
			add_definitions(-DUSE_OPENMP)
		else()
			message(STATUS "! OpenMP library not found! $>brew install libomp")
		endif()
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
		# using Visual Studio C++
		add_compile_options(/openmp)
		add_definitions(-DUSE_OPENMP)
	else()
		# using GCC & Clang++ (android)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fopenmp")
		add_definitions(-DUSE_OPENMP)
	endif()
endif()

if (USE_SKYLICHT_NETWORK)
	add_definitions(-DUSE_SKYLICHT_NETWORK)
endif()

# freetype font library
add_definitions(-DFT2_BUILD_LIBRARY)

include(${SKYLICHT_TARGETS_DIR}/ThirdPartyTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/SystemTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/AudioTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/IrrlichtTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/EngineTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/ComponentsTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/CollisionTargets.cmake)

if (USE_BULLET_PHYSIC_ENGINE)
include(${SKYLICHT_TARGETS_DIR}/LinearMathTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/Bullet3CommonTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/BulletCollisionTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/BulletDynamicsTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/BulletInverseDynamicsTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/BulletSoftBodyTargets.cmake)
endif()

include(${SKYLICHT_TARGETS_DIR}/PhysicsTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/CryptoLibTargets.cmake)

if (USE_SKYLICHT_NETWORK)
include(${SKYLICHT_TARGETS_DIR}/NetworkTargets.cmake)
endif()

include(${SKYLICHT_TARGETS_DIR}/LightmapperTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/UserInterfaceTargets.cmake)
include(${SKYLICHT_TARGETS_DIR}/ClientTargets.cmake)

if (USE_SKYLICHT_IMGUI)
include(${SKYLICHT_TARGETS_DIR}/ImguiTargets.cmake)
endif()