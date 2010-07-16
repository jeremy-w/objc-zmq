#!/bin/sh
ARCHS="i386 x86_64"
INSTALL_PREFIX="$PWD/execs"

# Build each architecture's files.
for A in $ARCHS; do
  echo "Cleaning project..."
  make clean  # clear out previous architecture's files

  echo "Building architecture: $A"
  echo "Install prefix: $INSTALL_PREFIX-$A"
  # -arch specifies the target architecture. --exec-prefix controls where the executables will be placed.
  CFLAGS="$CFLAGS -arch $A" CPPFLAGS="$CPPFLAGS $CFLAGS" LDFLAGS="$LDFLAGS -arch $A" ./configure --with-pic --exec-prefix="$INSTALL_PREFIX-$A" \
  && make \
  && make install-exec
done

# Smoosh the results together using lipo.
LIPO="`which lipo`"
mkdir "$INSTALL_PREFIX"  # final executables end up here

MODEL_ARCH="`echo \"$ARCHS\" | cut -d' ' -f1`"  # first architecture
# Really need a proper treewalk.
for DIR in "$INSTALL_PREFIX-$MODEL_ARCH/"*; do
  echo "Making files in $DIR fat..."
  DIRNAME=`basename "$DIR"`
  mkdir "$INSTALL_PREFIX/$DIRNAME"

  for FILE in $DIR/*; do
    FNAM=`basename $FILE`
    echo "Fattening $FNAM..."

    ARCH_FILES=""
    for A in $ARCHS; do
      ARCH_FILES="$ARCH_FILES $INSTALL_PREFIX-$A/$DIRNAME/$FNAM"
    done

    $LIPO -create -output "$INSTALL_PREFIX/$DIRNAME/$FNAM" $ARCH_FILES
  done
done

echo "Universal files should be under the $INSTALL_PREFIX directory."
