cmake_minimum_required(VERSION ${CMAKE_VERSION})

include(CheckFunctionExists)
include(CheckIncludeFile)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/meson.build
    VERSION_CONTENT REGEX "version : '([0-9]+)\\.([0-9]+)\\.([0-9]+)'")
string(REGEX MATCHALL "[0-9]+" VERSION_LIST ${VERSION_CONTENT})

list(LENGTH VERSION_LIST LIST_LEN)

if(LIST_LEN EQUAL 2)
    list(GET VERSION_LIST 0 VERSION_0)
    list(GET VERSION_LIST 1 VERSION_1)
    set(VERSION ${VERSION_0}.${VERSION_1})
elseif(LIST_LEN GREATER_EQUAL 3)
    list(GET VERSION_LIST 0 VERSION_0)
    list(GET VERSION_LIST 1 VERSION_1)
    list(GET VERSION_LIST 2 VERSION_2)
    set(VERSION ${VERSION_0}.${VERSION_1}.${VERSION_2})
endif()

message(STATUS "libXau version: ${VERSION}")

check_function_exists(explicit_bzero HAVE_EXPLICIT_BZERO)
check_function_exists(explicit_memset HAVE_EXPLICIT_MEMSET)
check_function_exists(pathconf HAVE_PATHCONF)
check_include_file(unistd.h HAVE_UNISTD_H)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/include/X11/Xauth.h
    ${PROJECT_BINARY_DIR}/include/X11/Xauth.h @ONLY)

add_library(Xau)
target_compile_definitions(Xau PRIVATE
    -D_GNU_SOURCE -D__EXTENSIONS__
    $<$<BOOL:${HAVE_EXPLICIT_BZERO}>:-DHAVE_EXPLICIT_BZERO>
    $<$<BOOL:${HAVE_EXPLICIT_MEMSET}>:-DHAVE_EXPLICIT_MEMSET>
    $<$<BOOL:${HAVE_PATHCONF}>:-DHAVE_PATHCONF>
    $<$<BOOL:${HAVE_UNISTD_H}>:-DHAVE_UNISTD_H>)
target_sources(Xau PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/AuDispose.c
    ${CMAKE_CURRENT_SOURCE_DIR}/AuFileName.c
    ${CMAKE_CURRENT_SOURCE_DIR}/AuGetAddr.c
    ${CMAKE_CURRENT_SOURCE_DIR}/AuGetBest.c
    ${CMAKE_CURRENT_SOURCE_DIR}/AuLock.c
    ${CMAKE_CURRENT_SOURCE_DIR}/AuRead.c
    ${CMAKE_CURRENT_SOURCE_DIR}/AuUnlock.c
    ${CMAKE_CURRENT_SOURCE_DIR}/AuWrite.c)
target_include_directories(Xau PUBLIC
    ${PROJECT_BINARY_DIR}/include)
target_link_libraries(Xau PRIVATE xorgproto)
set_property(TARGET Xau
    PROPERTY ARCHIVE_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/lib)
