cmake_minimum_required(VERSION 3.20)
project(MaskDetectionTool)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)


find_package(Qt6 COMPONENTS
        Core
        Gui
        Widgets
        REQUIRED)

add_executable(MaskDetectionTool main.mm)
target_link_libraries(MaskDetectionTool
        Qt::Core
        Qt::Gui
        Qt::Widgets
        "-framework Metal"
        "-framework MetalPerformanceShaders"
        "-framework AVFoundation"
        )

set_target_properties(MaskDetectionTool PROPERTIES
        MACOS_BUNDLE ON
        MACOS_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
        )
