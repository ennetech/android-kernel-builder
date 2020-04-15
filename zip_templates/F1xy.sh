#!/usr/bin/env bash
echo "iMMENSITY zip script"

echo "KERNEL_NAME: $1"
echo "OUT_DIR: $2"
echo "DIST_DIR: $3"
echo "BRANCH: $4"
echo "DATE: $5"
echo "GCC: $6"
echo "CLANG: $7"
echo "CONFIG: $8"

WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "WORKDIR: $WORKDIR"

DATE=$5

# Setting kernel name starting from branch name
BRANCH=$4
case $BRANCH in
  Q-raphael)
    NAME="LOS"
    ;;
  mi9fod-stuff)
    NAME="Mi9FOD"
    ;;
  *)
    NAME=$BRANCH
    ;;
esac

RANDOM_NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo "Using random folder name: $RANDOM_NAME"
ZIP_SOURCE=$WORKDIR/$RANDOM_NAME
mkdir -p $ZIP_SOURCE

OUTNAME="$8-$NAME-$5.zip"
echo "ZIP NAME: $OUTNAME"
# Duplicate base template
cp $WORKDIR/F1xy-template.zip $WORKDIR/$OUTNAME

# Copy files
cp $2/arch/arm64/boot/Image.gz-dtb $ZIP_SOURCE/Image.gz-dtb

# Update zip
cd $ZIP_SOURCE
zip -r ../$OUTNAME *
cd ..

# Move file to dist folder
mv $WORKDIR/$OUTNAME $3/$OUTNAME

# Add build info
MD5=$(md5sum $3/$OUTNAME | awk '{ print $1 }')
cat << EOF > $3/$OUTNAME.info
MD5: $MD5
KERNEL_NAME: $1
BRANCH: $4
DATE: $5
GCC: $6
CLANG: $7
CONFIG: $8
EOF
rm -r $ZIP_SOURCE