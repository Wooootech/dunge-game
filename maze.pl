#!/usr/bin/perl

if ($#ARGV < 0) {
	printf STDERR "usage: $0 <thickness (0-2)> {width} {height}\n";
	exit;
}

my $Thick = $ARGV[0];
my $Width = 10;
my $Height = 10;
if ($#ARGV > 0) {
	$Width = $ARGV[1];
}
if ($#ARGV > 1) {
	$Height = $ARGV[2];
}

use strict;
use warnings;

no warnings 'recursion';
no warnings 'uninitialized';

use List::Util qw/shuffle/;

### Constants

my ( $WIDTH, $HEIGHT ) = ( $Width, $Height );

my %DIRECTION = (
    N => { dy => -1, opposite => 'S' },
    S => { dy => 1,  opposite => 'N' },
    E => { dx => 1,  opposite => 'W' },
    W => { dx => -1, opposite => 'E' },
);

### Code

my $map = carve( [], $WIDTH / 2, $HEIGHT / 2, 'E' );
print output($map);

sub carve {
    my ( $map, $x0, $y0, $direction ) = @_;

    my $x1 = $x0 + $DIRECTION{$direction}{dx};
    my $y1 = $y0 + $DIRECTION{$direction}{dy};

    return if $x1 == 0 or $x1 == $WIDTH or $y1 == 0 or $y1 == $HEIGHT;
    return if defined $map->[$x1][$y1];

    $map->[$x0][$y0]{$direction} = 1;
    $map->[$x1][$y1]{ $DIRECTION{$direction}{opposite} } = 1;

    carve( $map, $x1, $y1, $_ ) for shuffle keys %DIRECTION;

    return $map;
}

sub output {
    my ($map) = @_;

    my $output = '';
    for my $y ( 0 .. $HEIGHT ) {
		my $next = '';
		my $tnext = '';
        for my $x ( 0 .. $WIDTH ) {
            if ( defined $map->[$x][$y] ) {
				if ($Thick) {
					if ($Thick > 1) {
						if ($map->[$x][$y]{N} && $map->[$x][$y]{W} && $map->[$x][$y]{S} && $map->[$x][$y]{E}) {
							$output	.= '#  #';
							$next	.= '    ';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{W} && $map->[$x][$y]{S} && $map->[$x][$y]{E}) {
							$output	.= '####';
							$next	.= '    ';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{N} && $map->[$x][$y]{S} && $map->[$x][$y]{E}) {
							$output	.= '#  #';
							$next	.= '#   ';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{N} && $map->[$x][$y]{W} && $map->[$x][$y]{E}) {
							$output	.= '#  #';
							$next	.= '    ';
							$tnext	.= '####';
						} elsif ($map->[$x][$y]{N} && $map->[$x][$y]{W} && $map->[$x][$y]{S}) {
							$output	.= '#  #';
							$next	.= '   #';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{N} && $map->[$x][$y]{W}) {
							$output	.= '#  #';
							$next	.= '   #';
							$tnext	.= '####';
						} elsif ($map->[$x][$y]{N} && $map->[$x][$y]{S}) {
							$output	.= '#  #';
							$next	.= '#  #';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{N} && $map->[$x][$y]{E}) {
							$output	.= '#  #';
							$next	.= '#   ';
							$tnext	.= '####';
						} elsif ($map->[$x][$y]{W} && $map->[$x][$y]{S}) {
							$output	.= '####';
							$next	.= '   #';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{W} && $map->[$x][$y]{E}) {
							$output	.= '####';
							$next	.= '    ';
							$tnext	.= '####';
						} elsif ($map->[$x][$y]{S} && $map->[$x][$y]{E}) {
							$output	.= '####';
							$next	.= '#   ';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{S}) {
							$output	.= '####';
							$next	.= '#  #';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{E}) {
							$output	.= '####';
							$next	.= '#   ';
							$tnext	.= '####';
						} elsif ($map->[$x][$y]{N}) {
							$output	.= '#  #';
							$next	.= '#  #';
							$tnext	.= '####';
						} elsif ($map->[$x][$y]{W}) {
							$output	.= '####';
							$next	.= '   #';
							$tnext	.= '####';
						} else {
							$output	.= '####';
							$next	.= '####';
							$tnext	.= '####';
						}
					} else {
						if ($map->[$x][$y]{S} && $map->[$x][$y]{E}) {
							$output	.= '#  #';
							$next	.= '    ';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{S}) {
							$output	.= '#  #';
							$next	.= '#  #';
							$tnext	.= '#  #';
						} elsif ($map->[$x][$y]{E}) {
							$output	.= '####';
							$next	.= '    ';
							$tnext	.= '####';
						} else {
							$output	.= '#  #';
							$next	.= '    ';
							$tnext	.= '#  #';
						}
					}
				} else {
					if ($map->[$x][$y]{S} && $map->[$x][$y]{E}) {
						$output	.= '   ';
						$next	.= '   ';
					} elsif ($map->[$x][$y]{S}) {
						$output	.= '  #';
						$next	.= '  #';
					} elsif ($map->[$x][$y]{E}) {
						$output	.= '   ';
						$next	.= '###';
					} else {
						$output	.= '###';
						$next	.= '###';
					}
				}
            }
            else {
				if ($Thick) {
					$output	.= '####';
					$next	.= '####';
					$tnext	.= '####';
				} else {
					$output	.= '###';
					$next	.= '###';
				}
            }
        }
        $output .= "\n";
		$output .= $next . "\n";
		if ($Thick) {
			$output .= $tnext . "\n";
		}
    }

    return $output;
}
