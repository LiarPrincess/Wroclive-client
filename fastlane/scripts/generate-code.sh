#!/bin/sh

echo "Changing dir to root"
cd ..

echo "Generating Sourcery files"
sourcery --config "./sourcery.yml" --disableCache

echo "Generating SwiftGen files"
swiftgen config run --config "./swiftgen.yml"
