# shellcheck shell=bash
TRIPLE=$1
ANDROID_SDK_LEVEL=$2
LLVM_PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64"
LLVM_BIN="$LLVM_PATH/bin"
# The Rust triple and the NDK triple differ for 32-bit ARM:
#   clang wrapper:  armv7a-linux-androideabi<api>-clang
#   sysroot headers: sysroot/usr/include/arm-linux-androideabi
case "$TRIPLE" in
armv7-linux-androideabi)
    NDK_CLANG_TRIPLE=armv7a-linux-androideabi
    NDK_SYSROOT_TRIPLE=arm-linux-androideabi
    ;;
*)
    NDK_CLANG_TRIPLE=$TRIPLE
    NDK_SYSROOT_TRIPLE=$TRIPLE
    ;;
esac
CLANG_PATH="$LLVM_BIN/${NDK_CLANG_TRIPLE}${ANDROID_SDK_LEVEL}-clang"
UTRIPLE="$(echo $TRIPLE | sed 's/-/_/g')"
UUTRIPLE="$(echo $UTRIPLE | tr a-z A-Z)"

export CC_$UTRIPLE="$CLANG_PATH"
export CXX_$UTRIPLE="${CLANG_PATH}++"
export AR_$UTRIPLE="$LLVM_BIN/llvm-ar"
export CARGO_TARGET_${UUTRIPLE}_LINKER="$CLANG_PATH"
export BINDGEN_EXTRA_CLANG_ARGS_$UTRIPLE="--sysroot=$LLVM_PATH/sysroot -I$LLVM_PATH/sysroot/usr/include/$NDK_SYSROOT_TRIPLE"
