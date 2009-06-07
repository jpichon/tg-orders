#!/usr/bin/perl -w

use strict;
use Test::More "no_plan";

require "tg-order.pl";

# Item

my $item1 = Item->new('Cool tee-shirt', 1, 15.02, 'C');
my $item2 = Item->new('Awesome tee', 1, 19.99, 'J');

can_ok($item1, $_) for qw(get_name get_person get_price get_quantity);

is($item1->get_name(), 'Cool tee-shirt', 'Item->get_name');
is($item2->get_quantity(), 1, 'Item->get_quantity');
is($item1->get_price(), 15.02, 'Item->get_price (1)');
is($item2->get_price(), 19.99, 'Item->get_price (2)');
is($item1->get_person(), 'C', 'Item->get_person');

# Order

my $o = Order->new("Test June '09", '52.64', '17.63');

can_ok($o, $_) for qw(add_item);

$o->add_item($item1);
$o->add_item($item2);

is($o->count_items, 2, 'Order->count_items');
is($o->total_items, 35.01, 'Order->total_items');
is($o->verify_total, 1, 'Order->verify_total');

my $o2 = Order->new("Test June '09", '52.64', '17.64');
$o2->add_item($item1);
$o2->add_item($item2);

is($o2->total_items, 35.01, 'Order->total_items (2)');
isnt($o2->verify_total, 1, 'Order->verify_total (wrong total)');
