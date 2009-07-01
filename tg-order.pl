#!/usr/bin/perl -w

use 5.8.0;
use strict;

{ package Item;

  sub new {
      my $class = shift;
      my ($name, $qty, $price, $person) = @_;

      my $self = {Name => $name,
		  Qty => $qty,
		  Price => $price,
		  Person => $person, };
      bless $self, $class;

      $self;
  }

  sub get_name {
      my $self = shift;

      $self->{Name};
  }

  sub get_quantity {
      my $self = shift;

      $self->{Qty};
  }

  sub get_price {
      my $self = shift;

      $self->{Price};
  }

  sub get_person {
      my $self = shift;

      $self->{Person};
  }
}

{ package Order;

  sub new {
      my $class = shift;
      my $order_name = shift;
      my $total_dollars = shift;
      my $shipping_fees = shift;

      my $self = {Items => [ () ],
		  Title => $order_name,
		  Shipping => $shipping_fees,
		  Total_dollars => $total_dollars,
		  Total_euro => 0,
		  Customs => 0, };
      bless $self, $class;

      $self;
  }

  sub add_item {
      my $self = shift;
      my $item = shift;

      push @{$self->{Items}}, $item;

      $self->{Items};
  }

  sub count_items {
      my $self = shift;

      scalar @{$self->{Items}};
  }

  sub total_items {
      my $self = shift;

      my $total = 0;

      for my $item (@{$self->{Items}}) {
	  $total += $item->get_price() * $item->get_quantity();
      }

      $total;
  }

  sub verify_total {
      my $self = shift;

      (($self->total_items() + $self->{Shipping}) ==  $self->{Total_dollars});
  }

  sub get_people_percent {
      my $self = shift;

      my %people;

      for my $item (@{$self->{Items}}) {
	  if (!exists($people{$item->get_person()})) {
	      $people{$item->get_person()} = 0;
	  }

	  $people{$item->get_person()} += $item->get_price();
      }

      for my $person (keys %people) {
	  $people{$person} = Util::floor(($people{$person} / $self->total_items() * 100), 2);
      }

      %people;
  }

  sub get_people_share_order {
      my $self = shift;

      my %percent = $self->get_people_percent();

      my %share_order;

      for my $person (keys %percent) {
	  $share_order{$person} =
	      Util::floor($self->{Total_euro} * $percent{$person}/100, 2);
      }

      %share_order;
   }

  sub get_people_share_customs {
      my $self = shift;

      my %percent = $self->get_people_percent();

      my %share_customs;

      for my $person (keys %percent) {
	  $share_customs{$person} =
	      Util::floor($self->{Customs} * $percent{$person}/100, 2);
      }

      %share_customs;
  }

  sub get_people_share_total {
      my $self = shift;

      my %share_order = $self->get_people_share_order();
      my %share_custom = $self->get_people_share_customs();

      my %share_total;


      for my $person (keys %share_order) {
	  $share_total{$person} = $share_order{$person} + $share_custom{$person};
      }

      %share_total;
  }

  sub process_items {
      my $self = shift;
      my @items = @_;

      for my $order_line (@items) {
	  my $name = shift @{$order_line};
	  my $qty = shift @{$order_line};
	  my $price = shift @{$order_line};

	  while ($qty > 0) {
	      print "Item: $name for $price\n";
	      my $person = <STDIN>;
	      chomp($person);

	      my $item = Item->new($name, 1, $price, $person);
	      $self->add_item($item);

	      $qty--;
	  }
      }

      $self;
  }

  sub print_items {
      my $self = shift;

      print $self->get_title()."\n";
      print "Item name\tQty\tPrice\tPerson\n";

      for my $item (@{$self->{Items}}) {
	  print $item->get_name()."\t";
	  print $item->get_quantity."\t";
	  print $item->get_price."\t";
	  print $item->get_person."\n";
      }
  }

  sub set_total_euro {
      my $self = shift;
      my $total_euro = shift;

      $self->{Total_euro} = $total_euro;

      $self->{Total_euro};
  }

  sub set_custom_charges {
      my $self = shift;
      my $customs = shift;

      $self->{Customs} = $customs;

      $self->{Customs};
  }

  sub get_title {
      my $self = shift;

      "ThinkGeek order ".$self->{Title}."\n";
  }
}

{ package Util;

  sub floor {
      my ($n, $places) = @_;
      my $factor = 10 ** ($places || 0);
      return int(($n * $factor) + ($n < 0 ? -1 : 1) * 0.1) / $factor;
  }
}

{ package TGParser;

  sub parse {
      my $file = shift;
      my @items;

      open(IN, '<', $file) or die "Can't open '$file': $!";

      while (<IN>) {
	  my @line = split(/\s/);
	  my $price = pop @line;
	  $price =~ s/\$//;
	  my $qty = pop @line;
	  while ($qty !~ /[\d]+/) {
	      $qty = pop @line;
	  }
	  my $item = join(' ', @line);
	  $item =~ s/\s{2,}/ /;
	  push @items, [$item, $qty, $price];
      }

      close IN or warn $!;

      @items;
  }
}

# # # # #
#
# Driver
#
# # #

if (defined($ARGV[0])) {

    my @items = TGParser::parse($ARGV[0]);

    print "Order title?\n";
    my $order_title = <STDIN>;
    chomp($order_title);

    print "Order total in dollars?\n";
    my $total = <STDIN>;
    chomp($total);

    print "And the shipping?\n";
    my $shipping = <STDIN>;
    chomp($shipping);

    print "Cool! Now, let's see who got what.\n";

    my $order = Order->new($order_title, $total, $shipping);
    $order->process_items(@items);

    print "Order total in euros?\n";
    my $total_euro = <STDIN>;
    chomp($total_euro);
    $order->set_total_euro($total_euro);

    print "Got screwed over by Customs yet?\n";
    my $custom_charges = <STDIN>;
    chomp($custom_charges);

    if ($custom_charges !~ /^\d+\.?\d*$/) { $custom_charges = 0; }

    $order->set_custom_charges($custom_charges);

    my %shares = $order->get_people_share_order();
    my %customs = $order->get_people_share_customs();
    my %totals = $order->get_people_share_total();

    for my $person (keys %shares) {
	my $share = $shares{$person};
	my $cust = $customs{$person};
	my $total = $totals{$person};
	print "$person owes $total ($share for order, $cust for customs).\n";
    }

}


1;
