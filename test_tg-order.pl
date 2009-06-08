#!/usr/bin/perl -w

use strict;
use Test::More "no_plan";

require "tg-order.pl";

###
# Item


my $item1 = Item->new('Cool tee-shirt', 1, 15.02, 'C');
my $item2 = Item->new('Awesome tee', 1, 19.99, 'J');

can_ok($item1, $_) for qw(get_name get_person get_price get_quantity);

is($item1->get_name(), 'Cool tee-shirt', 'Item->get_name');
is($item2->get_quantity(), 1, 'Item->get_quantity');
is($item1->get_price(), 15.02, 'Item->get_price (1)');
is($item2->get_price(), 19.99, 'Item->get_price (2)');
is($item1->get_person(), 'C', 'Item->get_person');

###
# Order

my $o = Order->new("Test June '09", '52.64', '17.63');

can_ok($o, $_) for qw(add_item count_items total_items verify_total get_people_percent);

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

#

my $item3 = Item->new('Cool tee-shirt', 1, 10, 'C');
my $item4 = Item->new('Random tee-shirt S', 1, 10, 'J');
my $item5 = Item->new('Random tee-shirt Dinosaur', 1, 10, 'J');
my $item6 = Item->new('Random tee-shirt S', 1, 20, 'C');
my $item7 = Item->new('Random tee-shirt Car', 1, 20, 'B');

my $o3 = Order->new("Test #2 June '09", '100', '30');
$o3->add_item($item3);
$o3->add_item($item4);
$o3->add_item($item5);
$o3->add_item($item6);
$o3->add_item($item7);

is($o3->count_items, 5, 'Order->count_items (2)');
is($o3->total_items, 70, 'Order->total_items (3)');
is($o3->verify_total, 1, 'Order->verify_total (2)');

my %ppl = $o3->get_people_percent();
is ($ppl{'B'}, 28.57, "People percent - B");
is ($ppl{'C'}, 42.85, "People percent - C");
is ($ppl{'J'}, 28.57, "People percent - J");
