BR2_EXTERNAL="br-external"
TARGET=""

function set_target() {
    if [ $# -ne 1 ]; then
        echo "Usage: set_target TARGET"
        return
    fi

    TARGET=$1
    echo "Set target: $TARGET"

    BULDROOT_OUTPUT="output/$TARGET"
    m "${TARGET}_defconfig"
}

function get_target() {
    echo "Target: $TARGET"
}

function find_top() {
    while [ "$PWD" != "/" ]; do
        if [ -f "$BR2_EXTERNAL/envsetup.sh" ]; then
            echo "$PWD"
            return
        fi
        cd ..
    done

    echo "Error: could not find top of the tree"
    return 1
}

function m() {
    local TOP
    TOP="$(find_top)" || return

    if [ -z $TARGET ]; then
        echo "Error: need to set target"
        set_target
        return
    fi

    make \
        BR2_EXTERNAL="$TOP/$BR2_EXTERNAL" \
        BR2_DL_DIR="$TOP/dl" \
        O="$TOP/$BULDROOT_OUTPUT" \
        -C "$TOP/buildroot" \
        -j$(nproc) \
        "$@"
}
