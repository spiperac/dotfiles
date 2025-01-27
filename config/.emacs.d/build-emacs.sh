#!bin/bash
./autogen.sh
./configure --with-pgtk --with-mailutils --with-native-compilation --with-imagemagick --with-tree-sitter --with-gnutls --with-modules --with-wide-int --with-rsvg --with-xml2
make -j$(nproc)
sudo make install

