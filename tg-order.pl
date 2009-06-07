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


1;
