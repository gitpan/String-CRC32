#!/usr/local/bin/perl5.004  -I./blib/arch -I./blib/lib

print "1..2\n";

require String::CRC32;

$v1 = String::CRC32::crc32("This is the test string");
print ($v1 == 1835534707 ? "ok 1\n" : "not ok 1\n");

$v1 = String::CRC32::crc32("This is another test string");
print ($v1 == 2154698217 ? "ok 2\n" : "not ok 2\n");

