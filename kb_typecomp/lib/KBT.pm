package KBT;
use KBT::Funcdef;
use KBT::Mapping;
use KBT::List;
use KBT::Tuple;
use KBT::Scalar;
use KBT::Struct;
use KBT::StructItem;
use KBT::Typedef;
use KBT::Typeref;
use KBT::ExtTyperef;
use KBT::DefineModule;
use KBT::UseModule;

use strict;
use File::Spec;

sub install_path
{
    return File::Spec->catpath((File::Spec->splitpath(__FILE__))[0,1], '');
}


1;
