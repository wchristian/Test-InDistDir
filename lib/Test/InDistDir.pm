use strict;
use warnings;
package Test::InDistDir;

# ABSTRACT: test environment setup for development with IDE

=head1 SYNOPSIS

    use Test::More;
    use Test::InDistDir;

    # when this is run from inside t/ with a default @INC, it will now be in the
    # dist dir and include ./lib in @INC

=head1 DESCRIPTION

This module helps run test scripts in IDEs like Komodo.

When running test scripts in an IDE i have to set up a project file defining the
dist dir to run tests in and a lib dir to load additional modules from. Often I
didn't feel like doing that, especially when i only wanted to do a small patch
to a dist. In those cases i added a BEGIN block to mangle the environment for
me.

This module basically is that BEGIN block. It automatically moves up one
directory when it cannot see the test script in "t/$scriptname" and includes
'lib' in @INC when there's no blib present. That way the test ends up with
almost the same environment it'd get from EUMM/prove/etc., even when it's
actually run inside the t/ directory.

At the same time it will still function correctly when called by
EUMM/prove/etc., since it does not change the environment in those cases.

=cut

use lib;
use File::Spec;

sub import {
    my $script = ( File::Spec->splitpath( $0 ) )[-1];

    chdir ".." if !-f "t/$script";
    lib->import( 'lib' ) if !grep { /\bblib\b/ } @INC;

    return;
}

1;
