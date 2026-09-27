#!/bin/bash

#printf "msg %s\n" $(date) >> log.txt
printf "%(%F-%H:%M:%S)T\n" >> log.txt
