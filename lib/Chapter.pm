use MooseX::Declare;

class Chapter {
    use Section;
    has chapter  => ( is => 'rw', isa => 'Int' );
    has title    => ( is => 'rw', isa => 'Str' );
    has tags     => ( is => 'ro', lazy_build => 1, isa => 'ArrayRef[Str]' );
    has sections => ( is => 'ro', lazy_build => 1, isa => 'ArrayRef[Section]' );

    method _build_tags()      { [] };
    method _build_sections()  { [] };

    method class() {
        join " ", @{ $self->tags };
    };
};
