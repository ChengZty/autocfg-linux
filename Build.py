#! /usr/bin/env python
# coding=utf-8
import os
import sys

import re


def get_file_path(args):
    full_path = os.path.abspath(args[1])
    if not os.path.exists(full_path):
        raise Exception("待Build文件: %s 不存在." % full_path)
    return full_path


def main():
    file_path = get_file_path(sys.argv)
    src_fo = open(file_path, 'r')
    target_fo = open("release/%s" % sys.argv[1], 'w')
    new_content = ''
    while True:
        line = src_fo.readline()
        if not line:
            break
        if line.strip(' ') is not '':
            m = re.search('#[^\n]*', line)
            annotations = ''
            if m:
                annotations = m.group()
                if annotations.startswith('#!') or annotations.startswith('#:'):
                    new_content += line
                    continue
            new_content += line.replace(str(annotations), '', -1)
    new_content = re.sub("\n+", "\n", new_content)
    for line in new_content.split("\n"):
        if line.strip(' ') is not '':
            target_fo.write(line + "\n")
    target_fo.close()
    src_fo.close()


if __name__ == '__main__':
    try:
        main()
    except Exception, e:
        print(e)
        exit(1)
    finally:
        exit(0)