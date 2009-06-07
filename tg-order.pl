#!/usr/bin/perl -w

use 5.10.0;
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

      my @items = ();

      my $self = {Items => [ @items ],
		  Title => $order_name,
		  Shipping => $shipping_fees,
		  Total_dollars => $total_dollars,
		  Total_euro => 0,
		  Customs => undef, };
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
	  $total += $item->get_price();
      }

      $total;
  }

  sub verify_total {
      my $self = shift;

      (($self->total_items() + $self->{Shipping}) ==  $self->{Total_dollars});
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

  sub get_title {
      my $self = shift;

      "ThinkGeek order ".$self->{Title}."\n";
  }

}

1;
