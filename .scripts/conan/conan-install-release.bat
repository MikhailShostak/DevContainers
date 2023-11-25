@echo off
set ROOT=%~dp0

conan install %ROOT% --output-folder=Build\Release -c tools.cmake.cmaketoolchain:generator=Ninja --build=missing %*
