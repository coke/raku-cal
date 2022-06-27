unit class App::Cal:ver<0.9>;

use Terminal::ANSIColor;

enum Months «
    :January(1) February March
    April       May      June
    July        August   September
    October     November December
»; 

our $YEAR;
our $MONTH;
our $DAY;

INIT {
    my $now = now.Date;
    $YEAR  = $now.year;
    $MONTH = $now.month;
    $DAY   = $now.day;
}

sub validate-year($year) {
    if $year > 9999 or $year < 0 {
        note "Must specify a year betwen 13 and 9999";
        exit 1;
    }
}

sub render-month(:$year=$YEAR, :$month=$MONTH, :$h, :$show-year=True) is export {
    validate-year($year);
    my @output;
    my $first = Date.new($year, $month, 1);
    my $days-in-month = $first.days-in-month;
    my $dow=$first.day-of-week; 

    my $title = Months($month);
    $title ~= " " ~ $year if $show-year; 
    my $padding = (20 - $title.chars)/2.floor;

    my $bold  = $h ?? '' !! BOLD;
    my $reset = $h ?? '' !! RESET;

    push @output, " " x $padding, $bold, $title, $reset, "\n";
    push @output, "Su Mo Tu We Th Fr Sa\n";
    push @output, "   " x $dow unless $dow > 6;

    my $pday = 1;
    while $pday <= $days-in-month {
        if $pday == $DAY && $year == $YEAR && $month == $MONTH {
            push @output, $bold, $pday.fmt("%2i"), $reset;
        } else {
            push @output, $pday.fmt("%2i");
        }

        if $pday != $days-in-month {
            if $dow == 6  {
                push @output, "\n";
            } else {
                push @output, " ";
            }
        }
        $pday++;
        $dow++; $dow %= 7;
    }
    return @output.join;
}

sub render-year(:$year, :$h) is export {
    validate-year($year);
    my @output;
    my $bold  = $h ?? "" !! BOLD;
    my $reset = $h ?? "" !! RESET;
    my $padding = (64 - $year.chars)/2.floor;
    push @output, " " x $padding ~ $bold ~ $year ~ $reset;
    push @output, "";
    my @months;
    for 1..12 -> $month {
        push @months, render-month(:$year, :$month, :$h, :!show-year);
    }
    for @months -> $one, $two, $three {
        my @one = $one.lines;
        my @two = $two.lines;
        my @three = $three.lines;
        for ^8 -> $row {
            my $a = pad-right(@one[$row] // "", 20);
            my $b = pad-right(@two[$row] // "", 20);
            my $c = pad-right(@three[$row] // "", 20);
            push @output, $a.chomp ~ "  " ~ $b.chomp ~ "  " ~ $c.chomp
        }
    }

    @output.join("\n");
}

sub pad-right($str is copy, $pad) {
    $str ~ " " x ($pad - (colorstrip $str).chars);
}
