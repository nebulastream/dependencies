set(VERSION v4.3.5)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zeromq/libzmq
    REF "${VERSION}"
    SHA512 108d9c5fa761c111585c30f9c651ed92942dda0ac661155bca52cc7b6dbeb3d27b0dd994abde206eacfc3bc88d19ed24e45b291050c38469e34dca5f8c9a037d
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

# ensure the directories exist
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/zeromq/cmake)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/share/zeromq/cmake)

# move CMake files to the correct location
file(GLOB_RECURSE RELEASE_CMAKE_FILES "${CURRENT_PACKAGES_DIR}/lib/cmake/*")
file(GLOB_RECURSE DEBUG_CMAKE_FILES "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/*")

foreach(FILE ${RELEASE_CMAKE_FILES})
    file(INSTALL
        DESTINATION ${CURRENT_PACKAGES_DIR}/share/zeromq/cmake
        TYPE FILE
        FILES ${FILE}
    )
endforeach()

foreach(FILE ${DEBUG_CMAKE_FILES})
    file(INSTALL
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/share/zeromq/cmake
        TYPE FILE
        FILES ${FILE}
    )
endforeach()

# clean up the old cmake directories
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

vcpkg_cmake_config_fixup(
    CONFIG_PATH share/zeromq/cmake
)

# clean up unnecessary directories
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc
                    ${CURRENT_PACKAGES_DIR}/debug/share/doc
                    ${CURRENT_PACKAGES_DIR}/debug/share
                    ${CURRENT_PACKAGES_DIR}/debug/include)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

# check if the licence file exists
if(EXISTS ${SOURCE_PATH}/LICENSE)
    file(INSTALL
        DESTINATION ${CURRENT_PACKAGES_DIR}/share/zeromq
        TYPE FILE
        FILES ${SOURCE_PATH}/LICENSE
    )
else()
    message(WARNING "LICENSE file not found in the source directory")
endif()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

# double-check build artifacts
message(STATUS "Contents of lib directory after installation:")
execute_process(COMMAND ls -l "${CURRENT_PACKAGES_DIR}/lib" OUTPUT_VARIABLE LIB_DIR_CONTENTS)
message(STATUS "${LIB_DIR_CONTENTS}")

# debugging steps to verify file locations
message(STATUS "Verifying symbolic links and installation paths")

execute_process(COMMAND ls -l ${CURRENT_PACKAGES_DIR}/lib
    OUTPUT_VARIABLE LIB_DIR_CONTENTS)
message(STATUS "Contents of lib directory:\n${LIB_DIR_CONTENTS}")

execute_process(COMMAND ls -l ${CURRENT_PACKAGES_DIR}/debug/lib
    OUTPUT_VARIABLE DEBUG_LIB_DIR_CONTENTS)
message(STATUS "Contents of debug/lib directory:\n${DEBUG_LIB_DIR_CONTENTS}")

execute_process(COMMAND ls -l ${CURRENT_PACKAGES_DIR}/share/zeromq/cmake
    OUTPUT_VARIABLE SHARE_CMAKE_DIR_CONTENTS
    ERROR_VARIABLE SHARE_CMAKE_DIR_ERROR
    RESULT_VARIABLE SHARE_CMAKE_DIR_RESULT)
if (NOT SHARE_CMAKE_DIR_RESULT EQUAL 0)
    message(WARNING "Contents of share/zeromq/cmake directory:\n${SHARE_CMAKE_DIR_ERROR}")
else()
    message(STATUS "Contents of share/zeromq/cmake directory:\n${SHARE_CMAKE_DIR_CONTENTS}")
endif()

