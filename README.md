# AKB: Android Kernel Builder

## Introduction
This project started as a build script for exercising in android kernel development and quickly become an attempt to put batteries in android kernel building. I know that it is very early stage, but nevertheless i wanted to share it.

## Folder hierarcy
```
|-- _ccache  
|-- _out_<<KERNEL_NAME>>_<<KERNEL_BRANCH>> << Every build will have it's separate out folder
|-- kernel_<<CONFIG_NAME>>  << Every kernel will be cloned in a pattern like this
|-- akb
|-- dist             << Flashable zips will be put here
|-- kernel_templates << Contains .config files for building specification
|-- tools            << Here will be downloaded the toolchains
|   |-- bin
|   |-- clang
|   `-- gcc
`-- zip_templates
```
## Adding support for a new kernel
0. Take a look into ```zip_templates``` and ```kernel_templates``` to have a sense about how thing works
1. Create the .config and put it in the ```kernel_templates``` directory
2. Create the zip packing script and put it in the ```zip_templates```

## Functionalities
- Automatically configure the basic build envrioment
- Automatically download build gcc/clang toolchains
- Cache every GCC or CLANG provider on first use

## Available GCC providers
- GOOGLE
- LOS

## Available CLANG providers
- GOOGLE
- BENZO-BUILD 
- PROTON-BUILD
- PROTON-PREBUILT
- LOLZ

## Example usage (for a kernel that already has a .config)
This will build iMMENSITY kernel for Xiaomi Mi 9T Pro
```
git clone https://github.com/ennetech/android-kernel-builder.git
cd android-kernel-builder
docker run --rm -ti -v $(pwd):/data ubuntu:bionic
cd /data
chmod +x ./akb
./akb iMMENSITY-rapahel
```
This specific build will:
- Clone kernel from source
- Clone LOS GCC
- Build proton clang from source
- Build both variant of the kernel
- Create zips ready to flash ('dist' directory)

## Roadmap
- Clean up the code, there is a lot of duplication
- Support more kernels

## Contributing
Just open a merge request, any improvement or new .config is warmly accepted!

Wanna buy me a coffee?: [Click here!](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3A3BGU6A4MXRU&currency_code=EUR&source=url)

# License
Do whatever