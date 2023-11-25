from conan import ConanFile, tools
from conan.tools.cmake import CMake

import os, yaml, glob, hashlib, argparse
from pathlib import PureWindowsPath

class TargetGenerator(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"

    project_base_dir = '.'
    project_path = None
    target_name = None
    _target = None

    @property
    def target(self):
        if self._target:
            return self._target

        project_files = glob.glob(f'{self.project_base_dir}/*.project')
        self.project_path = os.path.join(os.getcwd(), project_files[0])

        print(f'Loading {self.target_name} target from {self.project_path}')

        project = None
        with open(self.project_path, 'r') as f:
            project = yaml.load(f, Loader=yaml.FullLoader)

        for target in project['Targets']:
            if target['Name'] == self.target_name:
                self._target = target
                return self._target

        raise RuntimeError(f'Target \"{self.target_name}\" not found.')

    def get_source_paths(self, project_base_dir):
        paths = glob.glob(f'{self.project_base_dir}/{project_base_dir}/**/*.cpp', recursive=True)
        return [PureWindowsPath((os.path.normpath(path))).as_posix() for path in paths]

    def get_all_subfolder_paths(self, project_base_dir):
        return [name for name in glob.glob(f'{self.project_base_dir}/{project_base_dir}/**/*/', recursive=True) if os.path.isdir(name)]

    def save_file(self, path, content):
        content_hash = hashlib.sha256(content.encode()).hexdigest()
        file_hash = hashlib.sha256(open(path, 'rb').read()).hexdigest() if os.path.isfile(path) else None

        print(f'{path}: {file_hash} -> {content_hash}')
        if file_hash != content_hash:
            tools.files.save(self, path, content)

    def requirements(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--output-folder', type=str, help='Specify output folder path')
        args, _ = parser.parse_known_args()

        self.target_name = os.path.basename(args.output_folder)

        self.project_base_dir = os.path.normpath(os.path.abspath(os.path.join(os.getcwd(), self.project_base_dir)))

        for dependency in self.target['Dependencies']:
            package = dependency.split(' as ')[0].strip()
            print(package)
            self.requires(package)

    def generate(self):
        cmake_project_path = os.path.join(str(self.folders.build_folder), 'CMakeLists.txt')
        self.output.info(f'Generate {cmake_project_path}')

        cmake_find_packages = []
        cmake_link_packages = []

        target_files = glob.glob(f'{os.getcwd()}/*Targets.cmake')

        for path in target_files:
            package = os.path.basename(path).split('Targets.cmake')[0]
            if package.startswith('module-'):
                continue
            cmake_find_packages.append(f'find_package({package} REQUIRED)')

        import re
        for path in target_files:
            with open(path) as f:
                for line in f:
                    match = re.search(r"Conan: Target declared '([^']+)'", line)
                    if match:
                        cmake_target = match.group(1)
                        cmake_link_packages.append(cmake_target)

        version = self.target['Version']

        cmake_content = [
            'cmake_minimum_required(VERSION 3.5)',
            f'project({self.target_name} VERSION {version})',
            'set(CMAKE_CXX_STANDARD 17)',
            'set(CMAKE_CXX_STANDARD_REQUIRED True)',
        ]

        if cmake_find_packages:
            cmake_content.extend(cmake_find_packages)

        source_base_dir = f'{self.target_name}/Source'
        include_base_dir = f'{self.target_name}/Include'

        source_cpp_paths = self.get_source_paths(source_base_dir)
        include_subfolders = self.get_all_subfolder_paths(include_base_dir)
        source_subfolders = self.get_all_subfolder_paths(source_base_dir)

        print(f'Source Paths: {source_cpp_paths}')
        print(f'Include Subfolders: {include_subfolders}')
        print(f'Source Subfolders: {source_subfolders}')

        cmake_sources = ' '.join(source_cpp_paths)

        cmake_content.append(f'add_executable({self.target_name} {cmake_sources})')
        if cmake_link_packages:
            packages = ' '.join(cmake_link_packages)
            cmake_content.append(f'target_link_libraries({self.target_name} {packages})')

        cmake_content = '\n'.join(cmake_content)

        print(cmake_content)

        self.save_file(cmake_project_path, cmake_content)

        cmake = CMake(self)
        cmake.configure(build_script_folder=self.folders.build_folder)

    def build(self):
        cmake = CMake(self)
        cmake.configure(build_script_folder=self.folders.build_folder)
        cmake.build()
