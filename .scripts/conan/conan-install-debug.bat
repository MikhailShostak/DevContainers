@echo off
set ROOT=%~dp0

conan install %ROOT% --output-folder=Build\Debug -c tools.cmake.cmaketoolchain:generator=Ninja --settings=build_type=Debug --build=missing %*
