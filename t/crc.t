#!/usr/local/bin/perl  -I./blib/arch -I./blib/lib

$string1 = "This is the test string";

$l1 = length($string1);

print "1..", $l1+3, "\n";

require String::CRC32;

$v1 = String::CRC32::crc32($string1);
print ($v1 == 1835534707 ? "ok 1\n" : "not ok 1\n");

$v1 = String::CRC32::crc32("This is another test string");
print ($v1 == 2154698217 ? "ok 2\n" : "not ok 2\n");

$i = 2;

for ($j = 0; $j <= $l1; $j++) {
  $v1 = String::CRC32::crc32(substr($string1, 0, $j));
  $v1 = String::CRC32::crc32(substr($string1, $j), $v1);
  $i++;
  print ($v1 == 1835534707 ? "ok $i\n" : "not ok $i\n");
}
