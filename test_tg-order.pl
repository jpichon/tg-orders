#!/usr/bin/perl -w

use strict;
use Test::More "no_plan";

require "tg-order.pl";

# Item

my $item1 = Item->new('Cool tee-shirt', 1, 15.02, 'C');
my $item2 = Item->new('Awesome tee', 1, 19.99, 'J');

can_ok($item1, $_) for qw(get_name get_person get_price get_quantity);

is($item1->get_name(), 'Cool new tee-shirt', 'Item->get_name');
is($item2->get_quantity(), 1, 'Item->get_quantity');
is($item1->get_price(), 15.02, 'Item->get_price (1)');
is($item2->get_price(), 19.99, 'Item->get_price (2)');
is($item1->get_person(), 'C', 'Item->get_person');
