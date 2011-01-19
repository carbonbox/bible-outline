use MooseX::Declare;

class Book {
    use Chapter;
    has name     => ( is => 'rw', isa => 'Str' );
    has chapters => ( is => 'ro', lazy_build => 1, isa => 'ArrayRef[Chapter]' );

    method _build_chapters()  { [] };
};
