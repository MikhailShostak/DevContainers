@echo off
set ROOT=%~dp0

conan build %ROOT% --output-folder=Build\Release -c tools.cmake.cmaketoolchain:generator=Ninja --build=missing %*
