#include <QApplication>
#include <QPushButton>
#include <Metal/Metal.h>
#include <MetalPerformanceShaders/MetalPerformanceShaders.h>
#include <iostream>

int main(int argc, char *argv[]) {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    std::cout << device.description.UTF8String << std::endl;
    std::cout << MPSSupportsMTLDevice(device) << std::endl;

    QApplication a(argc, argv);
    QPushButton button("Hello world!", nullptr);
    button.resize(200, 100);
    button.show();
    return QApplication::exec();
}
