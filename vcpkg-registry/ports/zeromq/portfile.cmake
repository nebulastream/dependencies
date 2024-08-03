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
    OPTIONS
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

# Ensure the directories exist
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/zeromq/cmake)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/share/zeromq/cmake)

# Move CMake files to the correct location
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

# Clean up the old cmake directories
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

# Fix up the package configuration
vcpkg_cmake_config_fixup(
    CONFIG_PATH share/zeromq/cmake
)

# Clean up unnecessary directories
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc
                    ${CURRENT_PACKAGES_DIR}/debug/share/doc
                    ${CURRENT_PACKAGES_DIR}/debug/include)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

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

