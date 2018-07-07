cmake_minimum_required(VERSION 3.6)
project(DOA_Test)

set(CMAKE_C_STANDARD 99)

set(SOURCE_FILES main.c DOA.c gcc_phat.c)
link_directories(/usr/local/lib /usr/lib/x86_64-linux-gnu)
add_executable(DOA_Test ${SOURCE_FILES})
target_link_libraries(DOA_Test fftw3 m)