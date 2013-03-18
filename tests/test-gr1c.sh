#!/bin/sh
# Tests not targeted at particular units.
#
# SCL; 2012, 2013.

set -e

BUILD_ROOT=..
PREFACE="============================================================\nERROR:"


################################################################
# Test realizability

REFSPECS="gridworld.spc gridworld_env.spc arbiter4.spc trivial_2var.spc"
UNREALIZABLE_REFSPECS="trivial_un.spc"

for k in `echo $REFSPECS`; do
    if ! $BUILD_ROOT/gr1c -r specs/$k > /dev/null; then
	echo $PREFACE "realizable specs/${k} detected as unrealizable\n"
	exit -1
    fi
done

for k in `echo $UNREALIZABLE_REFSPECS`; do
    if $BUILD_ROOT/gr1c -r specs/$k > /dev/null; then
	echo $PREFACE "unrealizable specs/${k} detected as realizable\n"
	exit -1
    fi
done


################################################################
# Synthesis regression tests

REFSPECS="trivial_2var.spc"

for k in `echo $REFSPECS`; do
    if ! ($BUILD_ROOT/gr1c -t txt specs/$k | cmp -s expected_outputs/${k}.listdump.out -); then
	echo $PREFACE "synthesis regression test failed for specs/${k}\n"
	exit -1
    fi
done


################################################################
# Test interaction;  N.B., quite fragile depending on interface

REFSPECS="trivial_partwin gridworld"

for k in `echo $REFSPECS`; do
    if ! $BUILD_ROOT/gr1c -i specs/${k}.spc < interaction_scripts/${k}_IN.txt | diff - interaction_scripts/${k}_OUT.txt > /dev/null; then
        echo $PREFACE "unexpected behavior in scripted interaction using specs/${k}\n"
        exit -1
    fi
done
