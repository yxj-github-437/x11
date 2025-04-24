cmake_minimum_required(VERSION 3.11)
project(xorgproto)

if(POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
endif()

include(FetchContent)

set(xorgproto_version 2024.1)
FetchContent_Declare(
    xorgproto
    URL https://xorg.freedesktop.org/releases/individual/proto/xorgproto-${xorgproto_version}.tar.xz
    URL_HASH SHA256=372225fd40815b8423547f5d890c5debc72e88b91088fbfb13158c20495ccb59
    PATCH_COMMAND
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.cmake <SOURCE_DIR>/CMakeLists.txt)
FetchContent_MakeAvailable(xorgproto)
