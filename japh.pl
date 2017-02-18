#!/usr/bin/perl

use strict;
use warnings;


# Toggle whether to use a newline.
my $use_newline = 0;
my $tape_size = 30_000;
my $program;

if ($#ARGV >= 0) {

  # Debug mode. Read a BF program from first arg.
  my $fn = $ARGV[0];
  open(my $fh, '<:encoding(UTF-8)', $fn)
    or die "Could not open filename '$fn' $!";
  $program = do { local $/; <$fh> };

} else {

  # Brainfuck program to execute.
  $program = join(
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

}

$program =~ tr/"+-<>[],."//cd;
my @program = split //, $program;

my @tape = (0) x $tape_size;
my $tape_pointer = 0;
my $program_counter = 0;
my $string_buffer;
my $num_open;
my %open_to_close;
my %close_to_open;

# Execute each instruction sequentially.
while ($program_counter < scalar(@program)) {
  my $instruction = $program[$program_counter];

  # Increment tape at current position.
  if ($instruction eq '+') {
    $tape[$tape_pointer] += 1;

  # Decrement tape at current position.
  } elsif ($instruction eq '-') {
    $tape[$tape_pointer] -= 1;

  # Print ascii character associated with value at current position.
  } elsif ($instruction eq '.') {
    print chr($tape[$tape_pointer]);

  } elsif ($instruction eq '>') {
    $tape_pointer = ($tape_pointer + 1) % $tape_size;

  } elsif ($instruction eq '<') {
    $tape_pointer = ($tape_pointer - 1) % $tape_size;

  } elsif ($instruction eq ',') {
    read(STDIN, $string_buffer, 1);
    $tape[$tape_pointer] = ord($string_buffer);

  } elsif ($instruction eq '[') {
    if ($tape[$tape_pointer] == 0) {
      if (exists $open_to_close{$program_counter}) {
        $program_counter = $open_to_close{$program_counter};
      } else {
        my $program_counter_tmp = $program_counter;
        $num_open = 1;
        while ($num_open >= 1) {
          $program_counter++;
          if ($program[$program_counter] eq '[') {
            $num_open++;
          } elsif ($program[$program_counter] eq ']') {
            $num_open--;
          }
        }
        $open_to_close{$program_counter_tmp} = $program_counter;
        $close_to_open{$program_counter} = $program_counter_tmp;
      }
      $program_counter++;
      next;
    }

  } elsif ($instruction eq ']') {
    if ($tape[$tape_pointer] != 0) {
      if (exists $close_to_open{$program_counter}) {
        $program_counter = $close_to_open{$program_counter};
      } else {
        my $program_counter_tmp = $program_counter;
        $num_open = 1;
        while ($num_open >= 1) {
          $program_counter--;
          if ($program[$program_counter] eq ']') {
            $num_open++;
          } elsif ($program[$program_counter] eq '[') {
            $num_open--;
          }
        }
        $close_to_open{$program_counter_tmp} = $program_counter;
        $open_to_close{$program_counter} = $program_counter_tmp;
      }
      next;
    }

  }

  $program_counter++;

}
