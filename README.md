# MulleObjCContainerFoundation

#### 🛍 Container classes like NSArray, NSSet, NSDictionary

These classes build on **MulleObjC** and **mulle-container** to provide the
usual containeres expected in a Foundation library.



| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCContainerFoundation.svg?branch=release) [![Build Status](https://github.com/MulleFoundation/MulleObjCContainerFoundation/workflows/CI/badge.svg?branch=release)](//github.com/MulleFoundation/MulleObjCContainerFoundation/actions) | [RELEASENOTES](RELEASENOTES.md) |


## API

### Immutable Classes

| Class         | Description
|---------------|----------------
|`NSArray`      |
|`NSSet`        |
|`NSDicionary`  |


### Mutable Containers

| Class                | Description
|----------------------|----------------
| `NSMutableArray`     |
| `NSMutableSet`       |
| `NSMutableDicionary` |






## Requirements

|   Requirement         | Release Version  | Description
|-----------------------|------------------|---------------
| [MulleObjC](https://github.com/mulle-objc/MulleObjC) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/MulleObjC.svg) [![Build Status](https://github.com/mulle-objc/MulleObjC/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-objc/MulleObjC/actions/workflows/mulle-sde-ci.yml) | 💎 A collection of Objective-C root classes for mulle-objc
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-list.svg) [![Build Status](https://github.com/mulle-objc/mulle-objc-list/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-objc/mulle-objc-list/actions/workflows/mulle-sde-ci.yml) | 📒 Lists mulle-objc runtime information contained in executables.

### You are here

![Overview](overview.dot.svg)

## Add

Use [mulle-sde](//github.com/mulle-sde) to add MulleObjCContainerFoundation to your project:

``` sh
mulle-sde add github:MulleFoundation/MulleObjCContainerFoundation
```

## Install

### Install with mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleObjCContainerFoundation and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com/MulleFoundation/MulleObjCContainerFoundation/archive/latest.tar.gz
```

### Manual Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [MulleObjC](https://github.com/mulle-objc/MulleObjC)             | 💎 A collection of Objective-C root classes for mulle-objc
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list)             | 📒 Lists mulle-objc runtime information contained in executables.

Download the latest [tar](https://github.com/MulleFoundation/MulleObjCContainerFoundation/archive/refs/tags/latest.tar.gz) or [zip](https://github.com/MulleFoundation/MulleObjCContainerFoundation/archive/refs/tags/latest.zip) archive and unpack it.

Install **MulleObjCContainerFoundation** into `/usr/local` with [cmake](https://cmake.org):

``` sh
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_PREFIX_PATH=/usr/local \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  


