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
  master)
    NAME="LOS"
    ;;
  sm8150-common)
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
cp $WORKDIR/iMMENSITY-template.zip $WORKDIR/$OUTNAME

# Write version
cat << EOF > $ZIP_SOURCE/version
    • Installing $NAME build
    • Built on $DATE
EOF

# Copy files
mkdir -p $ZIP_SOURCE/dtbs
cp $2/arch/arm64/boot/dts/qcom/sm8150-v2.dtb $ZIP_SOURCE/dtbs/sm8150-v2.dtb
cp $2/arch/arm64/boot/dtbo.img $ZIP_SOURCE/dtbo.img
cp $2/arch/arm64/boot/Image.gz $ZIP_SOURCE/Image.gz

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