#!/usr/bin/env bash

BUNDLE=opensuse

PACKAGING_DIR=$(dirname $(readlink -f $0))

DOWNLOAD_CACHE=$(dirname $(readlink -f $0))/../../download_cache

UNGOOGLED_DIR=$(dirname $(readlink -f $0))/../../../

pushd $PACKAGING_DIR
mkdir $DOWNLOAD_CACHE
cp -R $UNGOOGLED_DIR/buildkit .
cp -R $UNGOOGLED_DIR/config_bundles .
cp $UNGOOGLED_DIR/version.ini .
python3 -m buildkit downloads retrieve -b config_bundles/$BUNDLE -c $DOWNLOAD_CACHE
python3 -m buildkit downloads unpack -b config_bundles/$BUNDLE -c $DOWNLOAD_CACHE ../
python3 -m buildkit prune -b config_bundles/$BUNDLE ../
#python3 -m buildkit patches apply -b config_bundles/$BUNDLE ../
#In RPM prep step:
#python3 -m buildkit domains apply -b config_bundles/$BUNDLE -c domainsubcache.tar.gz ../
popd

cp -r $PACKAGING_DIR/patches/* ~/rpm/SOURCES/

pushd $PACKAGING_DIR/chromium-icons_contents
tar cjf ~/rpm/SOURCES/chromium-icons.tar.bz2 *
popd

cp $PACKAGING_DIR/ungoogled-chromium.spec ~/rpm/SPECS/

mv $PACKAGING_DIR/buildkit ..
mv $PACKAGING_DIR/config_bundles ..
mv $PACKAGING_DIR/version.ini ..
mv $PACKAGING_DIR/.. ~/rpm/BUILD/tree
