set(tensorflowlite_c_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/../../include")

set(tensorflowlite_c_INCLUDE_DIRS
        ${tensorflowlite_c_INCLUDE_DIR}
        ${tensorflowlite_c_INCLUDE_DIR}/tensorflow/lite/c
        )

add_library(tensorflowlite_c::tensorflowlite_c SHARED IMPORTED)

if (APPLE)
    set_target_properties(tensorflowlite_c::tensorflowlite_c
            PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_LIST_DIR}/../../lib/libtensorflowlite_c.dylib
            INTERFACE_INCLUDE_DIRECTORIES "${tensorflowlite_c_INCLUDE_DIR}"
            )
elseif (UNIX AND NOT APPLE)
    set_target_properties(tensorflowlite_c::tensorflowlite_c
            PROPERTIES
            IMPORTED_LOCATION ${CMAKE_CURRENT_LIST_DIR}/../../lib/libtensorflowlite_c.so
            INTERFACE_INCLUDE_DIRECTORIES "${tensorflowlite_c_INCLUDE_DIR}"
            )
else()
    message(FATAL_ERROR "Unsupported platform for tensorflow")
endif ()

set(tensorflowlite_c_FOUND TRUE)
