####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package typedoc;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 4 "typedoc.yp"

    use Devel::StackTrace;
    use KBT;
    use Data::Dumper;
    use File::Spec;

our %builtin_types = ('int' => KBT::Scalar->new(scalar_type => 'int'),
		      'string' => KBT::Scalar->new(scalar_type => 'string'),
		      'float' => KBT::Scalar->new(scalar_type => 'float'),
    );




sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		DEFAULT => -2,
		GOTOS => {
			'module_list' => 1,
			'start' => 2
		}
	},
	{#State 1
		ACTIONS => {
			'' => -1
		},
		DEFAULT => -8,
		GOTOS => {
			'module_opts' => 3,
			'module' => 4
		}
	},
	{#State 2
		ACTIONS => {
			'' => 5
		}
	},
	{#State 3
		ACTIONS => {
			'MODULE' => 7,
			'AUTHENTICATED' => 6
		},
		GOTOS => {
			'module_opt' => 8
		}
	},
	{#State 4
		DEFAULT => -3
	},
	{#State 5
		DEFAULT => 0
	},
	{#State 6
		DEFAULT => -10
	},
	{#State 7
		DEFAULT => -4,
		GOTOS => {
			'@1-2' => 9
		}
	},
	{#State 8
		DEFAULT => -9
	},
	{#State 9
		ACTIONS => {
			'IDENT' => 10
		},
		GOTOS => {
			'mod_name_def' => 11
		}
	},
	{#State 10
		ACTIONS => {
			":" => 12
		},
		DEFAULT => -6
	},
	{#State 11
		ACTIONS => {
			"{" => 13
		}
	},
	{#State 12
		ACTIONS => {
			'IDENT' => 14
		}
	},
	{#State 13
		DEFAULT => -11,
		GOTOS => {
			'module_components' => 15
		}
	},
	{#State 14
		DEFAULT => -7
	},
	{#State 15
		ACTIONS => {
			"}" => 16,
			"use" => 21,
			'DOC_COMMENT' => 18,
			'TYPEDEF' => 22,
			'FUNCDEF' => 20
		},
		GOTOS => {
			'module_component' => 17,
			'funcdef' => 19,
			'typedef' => 23,
			'module_component_with_doc' => 24
		}
	},
	{#State 16
		ACTIONS => {
			";" => 25
		}
	},
	{#State 17
		DEFAULT => -13
	},
	{#State 18
		ACTIONS => {
			"use" => 21,
			'TYPEDEF' => 22,
			'FUNCDEF' => 20
		},
		GOTOS => {
			'module_component' => 26,
			'funcdef' => 19,
			'typedef' => 23
		}
	},
	{#State 19
		DEFAULT => -16
	},
	{#State 20
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 30,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'structure' => 32,
			'type' => 35,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 21
		ACTIONS => {
			"module" => 38
		}
	},
	{#State 22
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'structure' => 32,
			'type' => 40,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 23
		DEFAULT => -15
	},
	{#State 24
		DEFAULT => -12
	},
	{#State 25
		DEFAULT => -5
	},
	{#State 26
		DEFAULT => -14
	},
	{#State 27
		DEFAULT => -29
	},
	{#State 28
		DEFAULT => -30
	},
	{#State 29
		ACTIONS => {
			"<" => 41
		}
	},
	{#State 30
		ACTIONS => {
			'IDENT' => -34
		},
		DEFAULT => -20,
		GOTOS => {
			'@3-2' => 42
		}
	},
	{#State 31
		ACTIONS => {
			"<" => 43
		}
	},
	{#State 32
		DEFAULT => -31
	},
	{#State 33
		ACTIONS => {
			"<" => 44
		}
	},
	{#State 34
		DEFAULT => -33
	},
	{#State 35
		ACTIONS => {
			'IDENT' => 45
		}
	},
	{#State 36
		ACTIONS => {
			"{" => 46
		}
	},
	{#State 37
		DEFAULT => -32
	},
	{#State 38
		ACTIONS => {
			'ident' => 47
		}
	},
	{#State 39
		DEFAULT => -34
	},
	{#State 40
		ACTIONS => {
			'IDENT' => 48
		}
	},
	{#State 41
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'tuple_types' => 49,
			'structure' => 32,
			'tuple_type' => 50,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 42
		ACTIONS => {
			"(" => 52
		}
	},
	{#State 43
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'tuple_type' => 53,
			'structure' => 32,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 44
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'structure' => 32,
			'type' => 54,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 45
		DEFAULT => -22,
		GOTOS => {
			'@4-3' => 55
		}
	},
	{#State 46
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'structure' => 32,
			'tuple' => 34,
			'type' => 58,
			'struct_items' => 57,
			'struct_item' => 56,
			'list' => 37
		}
	},
	{#State 47
		ACTIONS => {
			";" => 59
		}
	},
	{#State 48
		DEFAULT => -18,
		GOTOS => {
			'@2-3' => 60
		}
	},
	{#State 49
		ACTIONS => {
			"," => 61,
			">" => 62
		}
	},
	{#State 50
		DEFAULT => -43
	},
	{#State 51
		ACTIONS => {
			'IDENT' => 63
		},
		DEFAULT => -45
	},
	{#State 52
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'IDENT' => 39,
			'MAPPING' => 31,
			'LIST' => 33,
			'STRUCTURE' => 36
		},
		DEFAULT => -24,
		GOTOS => {
			'funcdef_param' => 65,
			'mapping' => 28,
			'structure' => 32,
			'funcdef_params' => 64,
			'type' => 66,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 53
		ACTIONS => {
			"," => 67
		}
	},
	{#State 54
		ACTIONS => {
			">" => 68
		}
	},
	{#State 55
		ACTIONS => {
			"(" => 69
		}
	},
	{#State 56
		DEFAULT => -37
	},
	{#State 57
		ACTIONS => {
			"}" => 70,
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'structure' => 32,
			'tuple' => 34,
			'type' => 58,
			'struct_item' => 71,
			'list' => 37
		}
	},
	{#State 58
		ACTIONS => {
			'IDENT' => 72
		}
	},
	{#State 59
		DEFAULT => -17
	},
	{#State 60
		ACTIONS => {
			";" => 73
		}
	},
	{#State 61
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'tuple_type' => 74,
			'structure' => 32,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 62
		DEFAULT => -42
	},
	{#State 63
		DEFAULT => -46
	},
	{#State 64
		ACTIONS => {
			"," => 75,
			")" => 76
		}
	},
	{#State 65
		DEFAULT => -25
	},
	{#State 66
		ACTIONS => {
			'IDENT' => 77
		},
		DEFAULT => -28
	},
	{#State 67
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 28,
			'tuple_type' => 78,
			'structure' => 32,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 68
		DEFAULT => -41
	},
	{#State 69
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'IDENT' => 39,
			'MAPPING' => 31,
			'LIST' => 33,
			'STRUCTURE' => 36
		},
		DEFAULT => -24,
		GOTOS => {
			'funcdef_param' => 65,
			'mapping' => 28,
			'structure' => 32,
			'funcdef_params' => 79,
			'type' => 66,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 70
		DEFAULT => -36
	},
	{#State 71
		DEFAULT => -38
	},
	{#State 72
		ACTIONS => {
			'NULLABLE' => 81,
			";" => 80
		}
	},
	{#State 73
		DEFAULT => -19
	},
	{#State 74
		DEFAULT => -44
	},
	{#State 75
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'LIST' => 33,
			'IDENT' => 39,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'funcdef_param' => 82,
			'mapping' => 28,
			'structure' => 32,
			'type' => 66,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 76
		ACTIONS => {
			'RETURNS' => 83
		}
	},
	{#State 77
		DEFAULT => -27
	},
	{#State 78
		ACTIONS => {
			">" => 84
		}
	},
	{#State 79
		ACTIONS => {
			"," => 75,
			")" => 85
		}
	},
	{#State 80
		DEFAULT => -39
	},
	{#State 81
		ACTIONS => {
			";" => 86
		}
	},
	{#State 82
		DEFAULT => -26
	},
	{#State 83
		ACTIONS => {
			"(" => 87
		}
	},
	{#State 84
		DEFAULT => -35
	},
	{#State 85
		ACTIONS => {
			";" => 88
		}
	},
	{#State 86
		DEFAULT => -40
	},
	{#State 87
		ACTIONS => {
			'TYPENAME' => 27,
			'TUPLE' => 29,
			'IDENT' => 39,
			'MAPPING' => 31,
			'LIST' => 33,
			'STRUCTURE' => 36
		},
		DEFAULT => -24,
		GOTOS => {
			'funcdef_param' => 65,
			'mapping' => 28,
			'structure' => 32,
			'funcdef_params' => 89,
			'type' => 66,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 88
		DEFAULT => -23
	},
	{#State 89
		ACTIONS => {
			"," => 75,
			")" => 90
		}
	},
	{#State 90
		ACTIONS => {
			";" => 91
		}
	},
	{#State 91
		DEFAULT => -21
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'start', 1, undef
	],
	[#Rule 2
		 'module_list', 0,
sub
#line 24 "typedoc.yp"
{ [] }
	],
	[#Rule 3
		 'module_list', 2,
sub
#line 25 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 4
		 '@1-2', 0,
sub
#line 28 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 5
		 'module', 8,
sub
#line 28 "typedoc.yp"
{
    KBT::DefineModule->new(options => $_[1],
			   @{$_[4]},
			   module_components => $_[6],
		           comment => $_[3]);
    }
	],
	[#Rule 6
		 'mod_name_def', 1,
sub
#line 36 "typedoc.yp"
{ [ module_name => $_[1], service_name => $_[1] ] }
	],
	[#Rule 7
		 'mod_name_def', 3,
sub
#line 37 "typedoc.yp"
{ [ module_name => $_[3], service_name => $_[1] ] }
	],
	[#Rule 8
		 'module_opts', 0,
sub
#line 40 "typedoc.yp"
{ [] }
	],
	[#Rule 9
		 'module_opts', 2,
sub
#line 41 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 10
		 'module_opt', 1, undef
	],
	[#Rule 11
		 'module_components', 0,
sub
#line 48 "typedoc.yp"
{ [] }
	],
	[#Rule 12
		 'module_components', 2,
sub
#line 49 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 13
		 'module_component_with_doc', 1, undef
	],
	[#Rule 14
		 'module_component_with_doc', 2,
sub
#line 54 "typedoc.yp"
{ $_[2]->comment($_[1]); $_[2] }
	],
	[#Rule 15
		 'module_component', 1, undef
	],
	[#Rule 16
		 'module_component', 1, undef
	],
	[#Rule 17
		 'module_component', 4, undef
	],
	[#Rule 18
		 '@2-3', 0,
sub
#line 63 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 19
		 'typedef', 5,
sub
#line 63 "typedoc.yp"
{ $_[0]->define_type($_[2], $_[3], $_[4]); }
	],
	[#Rule 20
		 '@3-2', 0,
sub
#line 66 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 21
		 'funcdef', 11,
sub
#line 67 "typedoc.yp"
{ KBT::Funcdef->new(return_type => $_[9], name => $_[2], parameters => $_[5],
			      comment => $_[3]); }
	],
	[#Rule 22
		 '@4-3', 0,
sub
#line 69 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 23
		 'funcdef', 8,
sub
#line 70 "typedoc.yp"
{ KBT::Funcdef->new(return_type => [$_[2]], name => $_[3], parameters => $_[6],
			      comment => $_[4]); }
	],
	[#Rule 24
		 'funcdef_params', 0,
sub
#line 74 "typedoc.yp"
{ [] }
	],
	[#Rule 25
		 'funcdef_params', 1,
sub
#line 75 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 26
		 'funcdef_params', 3,
sub
#line 76 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 27
		 'funcdef_param', 2,
sub
#line 79 "typedoc.yp"
{ { type => $_[1], name => $_[2] } }
	],
	[#Rule 28
		 'funcdef_param', 1,
sub
#line 80 "typedoc.yp"
{ { type => $_[1] } }
	],
	[#Rule 29
		 'type', 1, undef
	],
	[#Rule 30
		 'type', 1, undef
	],
	[#Rule 31
		 'type', 1, undef
	],
	[#Rule 32
		 'type', 1, undef
	],
	[#Rule 33
		 'type', 1, undef
	],
	[#Rule 34
		 'type', 1,
sub
#line 89 "typedoc.yp"
{ my $type = $_[0]->lookup_type($_[1]);
			if (!defined($type))
			{
			    $_[0]->emit_error("Attempt to use undefined type '$_[1]'");
			}
			$type }
	],
	[#Rule 35
		 'mapping', 6,
sub
#line 97 "typedoc.yp"
{ KBT::Mapping->new(key_type => $_[3], value_type=> $_[5]); }
	],
	[#Rule 36
		 'structure', 4,
sub
#line 100 "typedoc.yp"
{ KBT::Struct->new(items => $_[3]); }
	],
	[#Rule 37
		 'struct_items', 1,
sub
#line 103 "typedoc.yp"
{ [$_[1]] }
	],
	[#Rule 38
		 'struct_items', 2,
sub
#line 104 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 39
		 'struct_item', 3,
sub
#line 107 "typedoc.yp"
{ KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 0); }
	],
	[#Rule 40
		 'struct_item', 4,
sub
#line 108 "typedoc.yp"
{ KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 1); }
	],
	[#Rule 41
		 'list', 4,
sub
#line 111 "typedoc.yp"
{ KBT::List->new(element_type => $_[3]); }
	],
	[#Rule 42
		 'tuple', 4,
sub
#line 114 "typedoc.yp"
{ KBT::Tuple->new(element_types => $_[3]); }
	],
	[#Rule 43
		 'tuple_types', 1,
sub
#line 117 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 44
		 'tuple_types', 3,
sub
#line 118 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 45
		 'tuple_type', 1, undef
	],
	[#Rule 46
		 'tuple_type', 2,
sub
#line 122 "typedoc.yp"
{ $_[1] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 125 "typedoc.yp"
 

sub define_type
{
    my($self, $old_type, $new_type, $comment) = @_;
    my $def = KBT::Typedef->new(name => $new_type, alias_type => $old_type, comment => $comment);
    push(@{$self->YYData->{type_list}}, $def);
    $self->YYData->{type_table}->{$new_type} = $def;
    return $def;
}

sub types
{
    my($self) = @_;
    return $self->YYData->{type_list};
}

sub lookup_type
{
    my($self, $name) = @_;
    return $self->YYData->{type_table}->{$name};
}


sub parse
{
    my($self, $data, $filename) = @_;

    $self->init_state($data, $filename);
    my $res = $self->YYParse(yylex => \&Lexer, yyerror => \&Error);

    return ($res, $self->YYData->{error_count});;
}

sub init_state
{
    my($self, $data, $filename) = @_;

    #
    # Initialize type table to just the builtins.
    #
    $self->YYData->{type_table} = { %builtin_types };
    $self->YYData->{INPUT} = $data;
    $self->YYData->{line_number} = 1;
    $self->YYData->{filename} = $filename;
    $self->YYData->{error_count} = 0;
}


sub Error {
    my($parser) = @_;
    
    my $data = $parser->YYData;

    my $error = $data->{ERRMSG} || "Syntax error";

    $parser->emit_error($error);
}

sub emit_error {
    my($parser, $message) = @_;
    
    my $data = $parser->YYData;

    my $line = $data->{line_number};
    my $file = $data->{filename};

    my $token = $parser->YYCurtok;
    my $tval = $parser->YYCurval;

    if ($token eq 'IDENT')
    {
	$token = $tval;
    }
    

    print STDERR "$file:$line: $message (next token is '$token')\n";
    $data->{error_count}++;
}


sub Lexer {
    my($parser)=shift;

    my $data = $parser->YYData;
    my $bufptr = \$data->{INPUT};

    for ($$bufptr)
    {
	while ($_ ne '')
	{
	    # print "Top: '$_'\n";
	    next if (s/^[ \t]+//);
	    if (s/^\n//)
	    {
		$data->{line_number}++;
		next;
	    }
	    
	    if ($_ eq '')
	    {
		return ('', undef);
	    }
	    elsif (s/^(funcdef|typedef|module|list|mapping|structure|nullable|returns|authenticated|tuple)\b//)
	    {
		return (uc($1), $1);
	    }
	    elsif (s/^([A-Za-z][A-Za-z0-9_]*)//)
	    {
		my $str = $1;
		if ($builtin_types{$str})
		{
		    my $type = $data->{type_table}->{$str};
		    return('TYPENAME', $type);
		}
		else
		{
		    return('IDENT', $str);
		}
	    }
	    elsif (s,^/\*(.*?)\*/,,s)
	    {
		my $com = $1;
		if ($com =~ /^\*/)
		{
		    #
		    # It was a /** comment which is a doc-block. Return that as a token.
		    #
		    return('DOC_COMMENT', $com);
		}

		my @lines = split(/\n/, $com);
		$lines[0] =~ s/^\s*//;
		my @new = ($lines[0]);
		shift @lines;
		if (@lines)
		{
		    my $l = $lines[0];
		    $l =~ s/\t/        /g;
		    my($init_ws) = $l =~ /^(\s+)/;
		    my $x = length($init_ws);
		    # print "x=$x '$lines[0]'\n";
		    for my $l (@lines)
		    {
			$l =~ s/\t/        /g;
			$l =~ s/^\s{$x}//;
			push(@new, $l);
		    }
		}
		#$parser->{cur_comment} = $com;
		$parser->{cur_comment} = join("\n", @new);
		
		# Else just elide.
	    }
	    elsif (s/^(.)//s)
	    {
		return($1,$1);
	    }
	}
    }
}

#
# Return the current comment if there is one. Always
# clear the current comment.
#
sub get_comment
{
    my($self) = @_;
    my $ret = $self->{cur_comment};
    $self->{cur_comment} = "";
    $ret =~ s/^\s+//;
    $ret =~ s/\s+$//;
    return $ret;
}
    

1;
