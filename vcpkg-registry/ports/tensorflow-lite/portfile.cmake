set(VERSION v2.6.0)

set(VCPKG_CXX_FLAGS -std=c++14)
set(VCPKG_C_FLAGS "")

vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO tensorflow/tensorflow
        REF "${VERSION}"
        SHA512 d052da4b324f1b5ac9c904ac3cca270cefbf916be6e5968a6835ef3f8ea8c703a0b90be577ac5205edf248e8e6c7ee8817b6a1b383018bb77c381717c6205e05
        PATCHES
        	cstdintlib.patch
        	abseiltag.patch
)

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}/tensorflow/lite/c"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if (VCPKG_TARGET_IS_LINUX)
    file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libtensorflowlite_c.so DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
    file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/libtensorflowlite_c.so DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
elseif (VCPKG_TARGET_IS_OSX)
    file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libtensorflowlite_c.dylib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
    file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/libtensorflowlite_c.dylib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
endif()

file(COPY ${SOURCE_PATH}/tensorflow/lite/ DESTINATION
        ${CURRENT_PACKAGES_DIR}/include/tensorflow/lite)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/tensorflow-lite-c RENAME copyright)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/TensorflowLiteCConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/tensorflow-lite-c)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/tensorflow-lite-c/TensorflowLiteCConfig.cmake ${CURRENT_PACKAGES_DIR}/share/tensorflow-lite-c/tensorflow-lite-c-config.cmake)
