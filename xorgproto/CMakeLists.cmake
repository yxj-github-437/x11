cmake_minimum_required(VERSION ${CMAKE_VERSION})

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/meson.build
    VERSION_CONTENT REGEX "version : '([0-9]+)\\.([0-9]+)'")
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

message(STATUS "xorgproto version: ${VERSION}")

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/include/
    DESTINATION ${PROJECT_BINARY_DIR}/include/
    FILES_MATCHING PATTERN "*.h")

include(CheckStructHasMember)
check_struct_has_member("fd_set" fds_bits "sys/select.h" HAVE_FD_SET_FDS_BITS)
check_struct_has_member("fd_set" __fds_bits "sys/select.h" HAVE_FD_SET__FDS_BITS)

if(HAVE_FD_SET_FDS_BITS)
    set(USE_FDS_BITS "fds_bits")
elseif(HAVE_FD_SET___FDS_BITS)
    set(USE_FDS_BITS "__fds_bits")
else()
    message(FATAL_ERROR "Your fd_set is too weird.")
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/include/X11/Xpoll.h.in
    ${PROJECT_BINARY_DIR}/include/X11/Xpoll.h @ONLY)

add_library(xorgproto INTERFACE)
target_include_directories(xorgproto INTERFACE
    ${PROJECT_BINARY_DIR}/include)
