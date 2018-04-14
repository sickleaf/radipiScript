#!/bin/bash

keyDir=$1
secretKey=${keyDir}/seckey
cipherText=${keyDir}/cipher

mail=
pass=$(openssl rsautl -decrypt -inkey ${secretKey} -in ${cipherText})

echo $pass
