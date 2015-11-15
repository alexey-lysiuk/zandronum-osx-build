#!/bin/sh

HG_EXE=`which hg`

if [ -z $HG_EXE ]; then
	HG_EXE=/Applications/SourceTree.app/Contents/Resources/mercurial_local/hg_local
fi

CMAKE_EXE=`which cmake`

if [ -z $CMAKE_EXE ]; then
	CMAKE_EXE=/Applications/CMake.app/Contents/bin/cmake
fi

REPOSITORY=$1

if [ -z $REPOSITORY ]; then
	REPOSITORY=https://bitbucket.org/Torr_Samaho/zandronum
fi

set -o errexit

cd "`dirname \"$0\"`"

ROOT_DIR=`pwd`

if [ ! -e zandronum ]; then
	${HG_EXE} clone ${REPOSITORY} zandronum
fi

if [ ! -e build ]; then
	mkdir build
fi

cd build

TP_DIR=$ROOT_DIR/thirdparty/
GLEW_DIR=${TP_DIR}glew/
FMOD_DIR=${TP_DIR}fmod/
FMOD_LIB=${FMOD_DIR}lib/libfmodex.dylib
FSYNTH_DIR=${TP_DIR}fluidsynth/
FSYNTH_LIB_PREFIX=${FSYNTH_DIR}lib/lib
FSYNTH_LIBS=${FSYNTH_LIB_PREFIX}fluidsynth.a\;${FSYNTH_LIB_PREFIX}glib-2.0.a\;${FSYNTH_LIB_PREFIX}intl.a
SDL_DIR=${TP_DIR}/SDL/
OPENSSL_DIR=${TP_DIR}/openssl/
FRAMEWORKS=-framework\ AudioUnit\ -framework\ Carbon\ -framework\ Cocoa\ -framework\ IOKit

${CMAKE_EXE} -Wno-dev                                 \
	-DCMAKE_OSX_DEPLOYMENT_TARGET="10.5"              \
	-DCMAKE_EXE_LINKER_FLAGS="${FRAMEWORKS}"          \
	-DGLEW_INCLUDE_DIR=${GLEW_DIR}include             \
	-DFMOD_INCLUDE_DIR=${FMOD_DIR}inc                 \
	-DFMOD_LIBRARY=${FMOD_LIB}                        \
	-DFLUIDSYNTH_INCLUDE_DIR=${FLUIDSYNTH_DIR}include \
	-DFLUIDSYNTH_LIBRARIES=${FSYNTH_LIBS}             \
	-DOPENSSL_INCLUDE_DIR=${OPENSSL_DIR}include       \
	-DSDL_INCLUDE_DIR=${SDL_DIR}include               \
	-DSDL_LIBRARY=${SDL_DIR}lib/libSDL.a              \
	../zandronum

make

if [ ! -e libfmodex.dylib ]; then
	cp ${FMOD_LIB} .
fi
