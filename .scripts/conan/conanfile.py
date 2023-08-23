from conan import ConanFile, tools
from conan.tools.cmake import CMake

import os, yaml, glob, hashlib

class ProjectGenerator(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"

    project_base_dir = 'project'
    project_path = None
    project_name = None
    _project = None

    @property
    def project(self):
        if self._project:
            return self._project

        project_files = glob.glob(f'{self.project_base_dir}/*.project')

        self.project_path = os.path.join(os.getcwd(), project_files[0])
        self.project_name = os.path.splitext(os.path.basename(self.project_path))[0]

        print(f'Loading {self.project_path}')

        with open(self.project_path, 'r') as f:
            self._project = yaml.load(f, Loader=yaml.FullLoader)

        return self._project

    def get_source_paths(self, project_base_dir):
        return glob.glob(f'{self.project_base_dir}/{project_base_dir}/**/*.cpp', recursive=True)

    def get_all_subfolder_paths(self, project_base_dir):
        return [name for name in glob.glob(f'{self.project_base_dir}/{project_base_dir}/**/*/', recursive=True) if os.path.isdir(name)]

    def save_file(self, path, content):
        content_hash = hashlib.sha256(content.encode()).hexdigest()
        file_hash = hashlib.sha256(open(path, 'rb').read()).hexdigest() if os.path.isfile(path) else None

        print(f'{path}: {file_hash} -> {content_hash}')
        if file_hash != content_hash:
            tools.files.save(self, path, content)

    def requirements(self):
        for dependency in self.project['Dependencies']:
            self.requires(dependency)

    def generate(self):
        cmake_project_path = os.path.join(str(self.folders.build_folder), 'CMakeLists.txt')
        self.output.info(f'Generate {cmake_project_path}')

        cmake_find_packages = []
        cmake_link_packages = []

        for dependency in self.project['Dependencies']:
            package = dependency.split('/')[0]
            cmake_find_packages.append(f'find_package({package} REQUIRED)')
            cmake_link_packages.append(f'{package}::{package}')

        version = self.project['Version']

        cmake_content = [
            'cmake_minimum_required(VERSION 3.5)',
            f'project({self.project_name} VERSION {version})',
            'set(CMAKE_CXX_STANDARD 17)',
            'set(CMAKE_CXX_STANDARD_REQUIRED True)',
        ]

        if cmake_find_packages:
            cmake_content.extend(cmake_find_packages)

        source_base_dir = 'Source'
        include_base_dir = 'Include'

        source_cpp_paths = self.get_source_paths(source_base_dir)
        include_subfolders = self.get_all_subfolder_paths(include_base_dir)
        source_subfolders = self.get_all_subfolder_paths(source_base_dir)

        print(source_cpp_paths)
        print(include_subfolders)
        print(source_subfolders)

        cmake_sources = ' '.join(source_cpp_paths)

        cmake_content.append(f'add_executable({self.project_name} {cmake_sources})')
        if cmake_link_packages:
            packages = ' '.join(cmake_link_packages)
            cmake_content.append(f'target_link_libraries({self.project_name} {packages})')

        cmake_content = '\n'.join(cmake_content)

        print(cmake_content)

        self.save_file(cmake_project_path, cmake_content)

        cmake = CMake(self)
        cmake.configure(build_script_folder=self.folders.build_folder)

    def build(self):
        cmake = CMake(self)
        cmake.configure(build_script_folder=self.folders.build_folder)
        cmake.build()
