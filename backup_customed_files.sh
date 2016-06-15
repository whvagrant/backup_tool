#! /bin/bash

########################################################
# @desc Backup bin&sql directories
# @date 2016/06/15
#
# @author wanghao46@baidu.com
########################################################

function help()
{
    echo "Usage: $0 dir or $0 "
    echo "  exp: $0 bin"
}

# tar source dir to target dir
function tar_dir()
{
    s_dir=$HOME/$1
    t_file=$BAK_DIR/${1}.$date
    echo "s_dir   :"$s_dir
    echo "t_file  :"$t_file
    $tar -cvzf $t_file $s_dir
}

function main()
{
    if [ $dir == "all" ]; then
        s_dir="bin"
        tar_dir $s_dir
        s_dir="sql"
        tar_dir $s_dir
    else 
        s_dir=$dir
        tar_dir $dir
    fi
}

while [ $# -gt 1 ]; do
    case "$1" in 
        -h|-H|--help)
            help
            exit 0
            ;;
    esac

    case "$2" in
        *)
            echo "Please input right parameter !"
            help
            exit -1
            ;;
    esac

done

if [ $# == 1 ]; then
    dir=$1
    date=`date -d"0 day ago" +"%Y%m%d"`
elif [ $# == 0 ]; then
    dir="all"
    date=`date -d"0 day ago" +"%Y%m%d"`
fi

echo "dir  :"$dir
echo "date :"$date

tar=/home/map/.jumbo/bin/tar
HOME=/home/map/wanghao46
BAK_DIR=$HOME/bak/$date

if [ ! -d "$BAK_DIR" ]; then
    mkdir $BAK_DIR
fi

echo "HOME    :"$HOME
echo "BAK_DIR :"$BAK_DIR

main

