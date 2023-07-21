#!/bin/bash
#!/bin/bash

for SDK in /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/*/Applications
do
ln -fs ${TARGET_BUILD_DIR}/${FULL_PRODUCT_NAME} ${SDK}
done
