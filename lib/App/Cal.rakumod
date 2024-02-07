unit class App::Cal:ver<0.9.1>;

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
    if $year > 9999 or $year < 13 {
        note "Must specify a year between 13 and 9999";
        exit 1;
    }
}

sub render-month(:$year=$YEAR, :$month=$MONTH, :$h, :$n, :$w, :$show-year=True) is export {
    validate-year($year);
    my @output;
    my $first = Date.new($year, $month, 1);
    my $days-in-month = $first.days-in-month;
    my $last  = Date.new($year, $month, $days-in-month);
    my $dow=$first.day-of-week; 

    my $title = Months($month);
    $title ~= " " ~ $year if $show-year; 
    my $width = $n ?? 21 !! 20;
    my $padding = ($width - $title.chars)/2.floor;

    my $bold  = $h ?? '' !! BOLD;
    my $reset = $h ?? '' !! RESET;

    push @output, " " x $padding, $bold, $title, $reset, "\n";

    if !$n { 
        # horizontal, default
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
    } else {
        # $n: ncal
        my %days = <1 Mo 2 Tu 3 We 4 Th 5 Fr 6 Sa 7 Su>;
        my $begin = True;
        my $today = Date.new($YEAR, $MONTH, $DAY);
        for 1..7 -> $day-of-week {
           push @output, %days{$day-of-week}, ' ';
           my @range = ($first..$last).grep(*.day-of-week eq $day-of-week);
           if $begin {
               if @range[0] > $first {
                   push @output, '   ';
               } elsif @range[0] eq $first {
                   $begin = False;
               }
           }
           for @range -> $day {
               if $day eq $today {
                   push @output, $bold, $day.day.fmt("%3i"), $reset;
               } else {
                   push @output, $day.day.fmt("%3i");
               }
           }
           LAST {
               if $w {
                   # output week numbers
                   push @output, '   ';
                   for @range -> $end-of-week {
                       push @output, $end-of-week.week-number.fmt("%3i");
                       LAST {
                           if $last > $end-of-week {
                               push @output, $last.week-number.fmt("%3i");
                           }
                       }
                   }
               }
           }
           push @output, "\n";
        }
    }
    @output[*-1]:delete if @output[*-1] eq "\n";
    return @output.grep(?*).join;
}

sub render-year(:$year, :$h, :$n, :$w) is export {
    validate-year($year);
    my @output;
    my $bold  = $h ?? "" !! BOLD;
    my $reset = $h ?? "" !! RESET;
    my $padding = (64 - $year.chars)/2.floor;
    push @output, " " x $padding ~ $bold ~ $year ~ $reset;
    my @months;
    for 1..12 -> $month {
        push @months, render-month(:$year, :$month, :$h, :$n, :$w, :!show-year);
    }
    my $per-row = $n ?? 4 !! 3; 
    my $month-padding = $n ?? 21 !! 20;
    for @months.rotor($per-row).kv -> $row, $group {
        my $line = "";
        my @lines;
        my $max-lines = 0;
        for @($group) -> $month {
            my @month-lines = $month.lines;
            $max-lines = @month-lines.elems if @month-lines.elems > $max-lines;
            @lines.push: @month-lines;
        }
        for 0..^$max-lines -> $l {
            my @chunks;
            for @lines -> $month {
                push @chunks, pad-right($month[$l] // "", $month-padding).chomp;
            }
            push @output, @chunks.join('  ');

        }
        push @output, "" unless $row == 12/$per-row - 1;
    }

    @output.join("\n");
}

sub pad-right($str is copy, $pad) {
    $str ~ " " x ($pad - (colorstrip $str).chars);
}
