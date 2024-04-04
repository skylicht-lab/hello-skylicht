# Target of install library from https://github.com/skylicht-lab/skylicht-engine
# skylicht-engine\BuildCommand\InstallLibVCPrj2022.cmd
set(SKYLICHT_TARGETS_DIR "./InstallLibs/cmake")

option(USE_SKYLICHT_SHARED_LIBS "Use skylicht shared libraries" OFF)
option(USE_SKYLICHT_NETWORK "Use skylicht network libraries" ON)
option(USE_SKYLICHT_IMGUI "Use imgui libraries" ON)
option(USE_BULLET_PHYSIC_ENGINE "Use bullet physics engine" ON)

if (NOT USE_SKYLICHT_SHARED_LIBS)
	add_definitions(-D_IRR_STATIC_LIB_)
	add_definitions(-D_SKYLICHT_STATIC_LIB_)
endif()

if (USE_BULLET_PHYSIC_ENGINE)
	add_definitions(-DUSE_BULLET_PHYSIC_ENGINE)
endif()

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