#!/usr/bin/perl

use strict;
use warnings;

# Toggle whether to use a newline.
my $use_newline = 0;

# Brainfuck program to execute.
my $string = join(
  '',
  '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.',
  '+++++++++++++++++++++++++++++++++++++++++++.--.+.--------------------------',
  '----------------------------------------------------------.++++++++++++++++',
  '+++++++++++++++++++++++++++++++++++++++++++++++++.+++++++++++++.+.+++++.---',
  '---------.---.+++++++++++++.-----------------------------------------------',
  '-----------------------------------.+++++++++++++++++++++++++++++++++++++++',
  '+++++++++.+++++++++++++++++++++.+++++++++++++.------.----------------------',
  '------------------------------------------------------.++++++++++++++++++++',
  '++++++++++++++++++++++++++++++++++++++++++++++++++++.-------.++.++++++++.--',
  '----.+++++++++++++.--------------------------------------------------------',
  '--------------.',
  ($use_newline) ? '----------------------------------.' : ''
);

# Declare minimal tape and tape pointer for this program.
my @tape = 0;
my $tape_pointer = 0;

# Execute each instruction sequentially.
foreach my $instruction (split //, $string) {

  # Increment tape at current position.
  if ($instruction eq '+') {
    $tape[$tape_pointer] += 1;

  # Decrement tape at current position.
  } elsif ($instruction eq '-') {
    $tape[$tape_pointer] -= 1;

  # Print ascii character associated with value at current position.
  } elsif ($instruction eq '.') {
    print chr($tape[$tape_pointer]);
  }
}
