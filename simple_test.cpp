#include <iostream>
extern "C" {
    const char* crypto_bridge_version();
}

int main() {
    std::cout << "Testing crypto bridge version: " << crypto_bridge_version() << std::endl;
    return 0;
}