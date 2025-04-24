cmake_minimum_required(VERSION 3.11)
project(libXau)

if(POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
endif()

include(FetchContent)

set(Xau_version 1.0.12)
FetchContent_Declare(
    libXau
    URL https://xorg.freedesktop.org/releases/individual/lib/libXau-${Xau_version}.tar.xz
    URL_HASH SHA256=74d0e4dfa3d39ad8939e99bda37f5967aba528211076828464d2777d477fc0fb
    PATCH_COMMAND
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.cmake <SOURCE_DIR>/CMakeLists.txt)
FetchContent_MakeAvailable(libXau)
