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

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/share/zeromq)

vcpkg_cmake_config_fixup(
    PACKAGE_NAME "zeromq"
    CONFIG_PATH "share/zeromq"
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc
                    ${CURRENT_PACKAGES_DIR}/debug/share
                    ${CURRENT_PACKAGES_DIR}/debug/include
)


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
