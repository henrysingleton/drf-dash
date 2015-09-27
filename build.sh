#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 version"
  exit 1
fi

DIR=$( cd "$( dirname $0 )" && pwd )
VERSION=$1
DOC_VERSION=${VERSION:0:3}
DOCSET_DIR="django-rest-framework-${DOC_VERSION}.docset"

echo "DOC VERSION: ${DOC_VERSION}"

mkdir -p build && cd build

if [ ! -d django-rest-framework ]; then
  git clone git@github.com:tomchristie/django-rest-framework.git
fi

cd django-rest-framework
git fetch origin
git checkout -b ${VERSION}-docs tags/${VERSION}

git apply ${DIR}/3.2.patch || echo "Is the patch already applied?"

mkdocs build --clean --quiet 2>&1 > /dev/null
status=$?
if [ $status -eq 0 ]; then
  echo "Generate docset......"
  cd ${DIR}/build
  mkdir -p ${DOCSET_DIR}/Contents/Resources/Documents
  cp -Rf django-rest-framework/site/* ${DOCSET_DIR}/Contents/Resources/Documents/
  
  cat << EOF > ${DOCSET_DIR}/Contents/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleIdentifier</key>
	<string>drf</string>
	<key>CFBundleName</key>
	<string>Django REST framework</string>
	<key>DocSetPlatformFamily</key>
	<string>drf</string>
	<key>isDashDocset</key>
	<true/>
  <key>dashIndexFilePath</key>
  <string>index.html</string>
  <key>isJavaScriptEnabled</key>
  <true/>
</dict>
</plist>
EOF
  
  python ../drfdoc2set.py ${DOC_VERSION} && tar --exclude='.DS_Store' -czf django-rest-framework-${DOC_VERSION}.tgz ${DOCSET_DIR} && echo " done."
fi
