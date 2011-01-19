use Modern::Perl;
use MooseX::Declare;

class Parser {
    use Carp qw/croak/;
    use Book;
    use Chapter;

    use constant TITLE   => qr/^(.*?)\s+(\d+)[\s:]+(.*)\s*$/;
    use constant SECTION => qr/^(\d+\w?)\s*-?\s*(\d+\w?)?\s+(\.*)(.*)\s*$/;
    has books => ( is => 'ro', lazy_build => 1, isa => 'ArrayRef[Book]' );

    method _build_books() { [] };

    method parse(Str $line) {
        chomp $line;

        state $current_book;
        state $current_chapter;

        # blank lines push us to the next chapter
        return $current_chapter = undef unless $line;

        # otherwise if we don't have a book, look for a title
        # if we do have a current, look for tags or verse
        if ($current_chapter) {
            if ($current_chapter->has_tags) {
                my ($start, $end, $indent, $summary) = $line =~ SECTION or croak "Expecting a section but got '$line'";
                push @{ $current_chapter->sections }, Section->new( start => $start, ($end ? (end => $end) : ()), summary => $summary, indent => length $indent );
            }
            else {
                push @{ $current_chapter->tags }, (split /\s+/, $line);
            }
        }
        else {
            my ($book, $chapter, $title) = $line =~ TITLE or croak "Expecting a title but got '$line'";
            push @{$self->books}, $current_book = Book->new( name => $book ) unless ($current_book && $current_book->name eq $book);
            push @{$current_book->chapters}, $current_chapter = Chapter->new( chapter => $chapter, title => $title );
        }
    }
};
