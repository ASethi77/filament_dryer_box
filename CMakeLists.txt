cmake_minimum_required(VERSION 3.27)

set(CMAKE_CXX_STANDARD 14)

include(cmake/configure_esp8266_toolchain.cmake)
include(cmake/CPM.cmake)
include(cmake/setup_venv.cmake)
include(cmake/apply_patch.cmake)
include(cmake/configure_esp_freertos_sdk.cmake)

setup_esp_freertos_sdk()

project(filament-dryer-box)

idf_build_get_property(IDF_PROJECT_EXECUTABLE EXECUTABLE)
message(STATUS "IDF EXE IS ${IDF_PROJECT_EXECUTABLE}")
add_custom_command(
        TARGET ${IDF_PROJECT_EXECUTABLE}
        POST_BUILD
        COMMAND "${CMAKE_OBJCOPY}" ARGS "-O" "ihex" "$<TARGET_FILE:${IDF_PROJECT_EXECUTABLE}>" "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}.hex"
        COMMENT "Creating .hex file from .elf"
)
add_custom_command(
        TARGET ${IDF_PROJECT_EXECUTABLE}
        DEPENDS "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}.hex"
        POST_BUILD
        COMMAND "${Python3_EXECUTABLE}" ARGS "${IDF_TOOLS_PATH}/idf_size.py" "--toolchain-prefix=xtensa-lx106-elf-" "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}.map"
        COMMENT "Dumping section headers for .hex image"
)
