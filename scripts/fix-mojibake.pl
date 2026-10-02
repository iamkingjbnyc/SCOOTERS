use strict;
use warnings;
use utf8;
binmode(STDOUT, ':utf8');

my @files = @ARGV;

for my $file (@files) {
    open(my $fh, '<:encoding(UTF-8)', $file) or die "Cannot open $file: $!";
    local $/;
    my $content = <$fh>;
    close($fh);

    my $before = $content;

    $content =~ s/ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â/—/g;   # em dash
    $content =~ s/ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œ/–/g;   # en dash
    $content =~ s/ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©/©/g;               # copyright
    $content =~ s/ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â·/·/g;               # middle dot

    if ($content ne $before) {
        open(my $out, '>:encoding(UTF-8)', $file) or die "Cannot write $file: $!";
        print $out $content;
        close($out);
        print "Fixed: $file\n";
    } else {
        print "No change: $file\n";
    }
}
