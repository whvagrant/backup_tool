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
    $tar -cvzf $t_file $s_dir > /dev/null 2>&1
    cp_file_to_remote $t_file
}

# backup local file to remote 
function cp_file_to_remote()
{
   s_file=$1 
   t_dir="/home/users/wanghao46/wanghao46/bak/"$date
   echo "s_file      :"$s_file
   echo "t_dir       :"$t_dir
   echo "remote host :"$remote_host
   command="if [ ! -d $t_dir ]; then
                mkdir $t_dir
            fi"
   
   ssh $remote_host "${command}"
   scp $s_file $remote_host:$t_dir
}

function main()
{
    if [ $dir == "all" ]; then
        for((i=0; $i<${#all_dir[@]}; i=i+1)); do
            tar_dir ${all_dir[$i]}
            echo ${all_dir[$i]}" done!"
        done
    else 
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

source $(dirname ${BASH_SOURCE[0]})/config.sh

if [ ! -d "$BAK_DIR" ]; then
    mkdir $BAK_DIR
fi

echo "HOME    :"$HOME
echo "BAK_DIR :"$BAK_DIR

main

