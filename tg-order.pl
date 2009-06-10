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

      my %people_percent = $self->get_people_percent();

  }

  sub get_people_share_customs {
      my $self = shift;

      my %people_percent = $self->get_people_percent();

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
      return int($n * $factor) / $factor;
  }
}

1;
