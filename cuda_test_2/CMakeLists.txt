cmake_minimum_required(VERSION 3.25)
project(cuda_test_2 LANGUAGES CXX CUDA)

add_executable(cuda_test_2 main.cu)

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
#include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)

find_package(glfw3 REQUIRED CONFIG)

set_target_properties(cuda_test_2 PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

target_link_libraries(cuda_test_2 PRIVATE glfw3)

