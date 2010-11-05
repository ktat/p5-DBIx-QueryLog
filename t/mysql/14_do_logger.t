use strict;
use warnings;
use Test::Requires qw(DBD::mysql Test::mysqld);
use Test::More;
use Test::mysqld;
use t::Util;
use DBIx::QueryLog ();
use DBI;

DBIx::QueryLog->logger(t::Util->new_logger);

my $mysqld = Test::mysqld->new(my_cnf => {
    'skip-networking' => '',
}) or plan skip_all => $Test::mysqld::errstr;

my $dbh = DBI->connect(
    $mysqld->dsn(dbname => 'mysql'), '', '',
    {
        AutoCommit => 1,
        RaiseError => 1,
    },
) or die $DBI::errstr;

DBIx::QueryLog->begin;

my $res = capture_logger {
    $dbh->do('SELECT * FROM user');
};

is $res->{sql}, 'SELECT * FROM user', 'query ok';

done_testing;
