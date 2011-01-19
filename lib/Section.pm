use MooseX::Declare;

class Section {
    has [qw/start end summary/] => ( is => 'rw', isa => 'Str' );
    has 'indent'                => ( is => 'rw', isa => 'Int' );

    method verses() {
        return $self->end ? $self->start . "&ndash;" . $self->end : $self->start;
    };

    method class() {
        return $self->indent ? "indent-" . $self->indent : "";
    };
};
