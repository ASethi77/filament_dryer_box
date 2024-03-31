function(setup_esp_freertos_sdk)
    if (NOT COMMAND CPMFindPackage)
        message(FATAL_ERROR "Could not find CPM. Please include CPM.cmake in the project before using this function.")
    endif()

    CPMFindPackage(
            NAME esp-idf
            VERSION 3.4
            GITHUB_REPOSITORY espressif/ESP8266_RTOS_SDK
            DOWNLOAD_ONLY true
            EXCLUDE_FROM_ALL true
            OPTIONS
                "CMAKE_TOOLCHAIN_FILE ${CMAKE_TOOLCHAIN_FILE}"
    )
    message(STATUS "ESP8266 SDK downloaded to ${esp-idf_SOURCE_DIR}")
    message(STATUS "Applying CMake patches to ESP8266_RTOS_SDK...")
    apply_git_patch(
            SRC_FOLDER ${esp-idf_SOURCE_DIR}
            PATCH_FILE "${CMAKE_SOURCE_DIR}/3rdparty/esp-idf-fix-GetGitRevisionDescription.patch"
    )
    apply_git_patch(
            SRC_FOLDER ${esp-idf_SOURCE_DIR}
            PATCH_FILE "${CMAKE_SOURCE_DIR}/3rdparty/esp-idf-disable-toolchain-override.patch"
    )

    set(ENV{IDF_PATH} "${esp-idf_SOURCE_DIR}")
    set(IDF_PATH "${esp-idf_SOURCE_DIR}" CACHE INTERNAL "Root folder for ESP8266 FreeRTOS SDK")
    set(IDF_TOOLS_PATH "${IDF_PATH}/tools" CACHE INTERNAL "Tools folder for ESP8266 FreeRTOS SDK")
    include($ENV{IDF_PATH}/tools/cmake/project.cmake)

    find_package (Python3 COMPONENTS Interpreter REQUIRED)
    if (NOT Python3_FOUND)
        message(FATAL_ERROR "Could not find Python3 on system.")
    else ()
        message(STATUS "Found Python at ${Python3_EXECUTABLE}")
    endif()
    setup_venv(
            REQUIREMENTS_PATH "${IDF_PATH}/requirements.txt"
    )
endfunction()