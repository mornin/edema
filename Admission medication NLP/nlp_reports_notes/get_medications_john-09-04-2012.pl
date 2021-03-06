#!/usr/bin/perl -w
#-*- perl -*-

use strict;
use warnings;

#Output Files:
#     ALL_PT_WITH_HOME_MEDS_HEADER.list: list of pt (<subject_id>
#       <hadm_id>) with admission meds sections (we will limit our
#       study to this pt cohort)
#     TRANSFER_SID.list: list of pt with transfer meds section in
#       their discharge summaries
#     nlp_found_admission_drugs.txt: this is the main output
#       containing list of pt with drugs in admission
#       medications. Format <subject_id> <hadm_id> <drug_name>
#     nlp.log: potential section headings

# Changes/Bug fixes:
# 03/30/12, djscott@mit.edu
#  Modify to read discharge summaries directly from DB
#  Process all drugs
# 12/13/11, lilehman@mit.edu
#  fixed parsing bugs that caused program to miss patterns such as "-omeprazole"
#  fixed bugs that missed the medications that are on the same line as the header
#  Added "Maternal" (medications) as a indicator for home medications
#  Change "transfer" medications to "other" instead of admission/home medications
# 12/19/2011, lilehman@mit.edu
#  Section heading such as "Medications:" or "Meds:" are now considered  as home/admission meds.

# Notes/Assumptions:
#  Section heading such as "Medications:" or "Meds:" are now considered  as home/admission meds.
#  "ethacrynic" is considred to refer to "ethacrynic acid"

use ProcessDischargeSummary;
use Term::ReadPassword;
use DBI;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($INFO);

# Setup DB connection
my $dsn = "dbi:Oracle:MIMIC2.TESLA.MIMIC.CSAIL.MIT.EDU";
#my $dsn = "dbi:Oracle:host=tesla.mimic.csail.mit.edu;sid=MIMIC2";
my $username = "djscott";

my $password = read_password("Password for $username: ");

my $dbh = DBI->connect($dsn, $username, $password);
$dbh->{LongReadLen} = 1024 * 1024; # 1MB
if (!defined($dbh)) {
    die("Failed to connect to database")
}

# open drug file output
open (DRUGFILE, ">nlp_found_admission_drugs.txt") || die "output nlp_found_admission_drugs.txt $!";

my $sth = $dbh->prepare("select subject_id, hadm_id, text from mimic2v26.noteevents where category = 'DISCHARGE_SUMMARY'") or die $dbh->errstr;
#my $sth = $dbh->prepare("select subject_id, hadm_id, text from mimic2v26.noteevents where category = 'DISCHARGE_SUMMARY' and subject_id < 10") or die $dbh->errstr;
$sth->execute;
while( my $ref = $sth->fetchrow_hashref('NAME_lc')) {
    my $line_count = 0;
    print "Subject ID:" . $ref->{'subject_id'} . " HADM ID:" . $ref->{'hadm_id'} . "\n";
    my $logger = get_logger();
    $logger->error("Processing subject ID:" . $ref->{'subject_id'} . " HADM ID:" . $ref->{'hadm_id'});
    my $hadm_id = $ref->{'hadm_id'};
    my $subject_id = $ref->{'subject_id'};

    my %disch_sum_results = proc_disch_sum($ref);

    # Check admission drugs for our list of interest
    my $insert_drug = $dbh->prepare("insert into djscott.mg_hr_meds (subject_id, hadm_id, section, med_type, med_name) values (?,?,?,?,?)") or die $dbh->errstr;
    for my $type ('admission','transfer','discharge') {
        if ($disch_sum_results{$type . '_drugs_section'}) {
            foreach my $drugname (@{$disch_sum_results{$type . '_drugs'}}) {
                $insert_drug->bind_param(1, $disch_sum_results{'subject_id'});
                $insert_drug->bind_param(2, $disch_sum_results{'hadm_id'});
                $insert_drug->bind_param(3, uc $type);

                if ($drugname =~ /ACEBUTOLOL|SECTRAL|ATENOLOL|TENORMIN|BETAXOLOL|KERLONE|BETOPTIC|BISOPROLOL|ZEBETA|ESMOLOL|BREVIBLOC|NEBIVOLOL|BYSTOLIC|METOPROLOL|LOPRESSOR|TOPROL|ACEBUTOLOL|SECTRAL|CARTEOLOL|OCUPRESS|PENBUTOLOL|LEVATOL|PINDOLOL|VISKEN|CARVEDILOL|COREG|LABETALOL|TRANDATE|LEVOBUNOLOL|BETAGAN|METIPRANOLOL|OPTIPRANOLOL|NADOLOL|CORGARD|PROPRANOLOL|INDERAL|INNOPRAN|SOTALOL|BETAPACE|SORINE|TIMOLOL|BETIMOL|BLOCADREN|ISTALOL|TIMOPTIC/i) {
                    $insert_drug->bind_param(4, 'BETA_BLOCKER');
                    $insert_drug->bind_param(5, $drugname);
                    $insert_drug->execute || $logger->error($insert_drug->errstr);
                    print DRUGFILE $disch_sum_results{'subject_id'} . "\t" . $disch_sum_results{'hadm_id'} . "\t" . $type . "\t" . 'BETA_BLOCKER' . "\t" . $drugname . "\n";
                }
                if ($drugname =~ /AMLODIPINE|NORVASC|CADUET|LOTREL|EXFORGE|DILTIAZEM|CARDIZEM|DILACOR|TAZTIA|TIAZAC|FELODIPINE|ISRADIPINE|NICARDIPINE|CARDENE|NIFEDIPINE|ADALAT|PROCARDIA|NISOLDIPINE|SULAR|VERAPAMIL|CALAN|ISOPTIN/i) {
                    $insert_drug->bind_param(4, 'CALCIUM_CHANNEL_BLOCKERS');
                    $insert_drug->bind_param(5, $drugname);
                    $insert_drug->execute || $logger->error($insert_drug->errstr);
                    print DRUGFILE $disch_sum_results{'subject_id'} . "\t" . $disch_sum_results{'hadm_id'} . "\t" . $type . "\t" . 'CALCIUM_CHANNEL_BLOCKERS' . "\t" . $drugname . "\n";
                }
                if ($drugname =~ /DIGITEK|LANOXICAPS|LANOXIN|CARDOXIN/i) {
                    $insert_drug->bind_param(4, 'DIGOXIN');
                    $insert_drug->bind_param(5, $drugname);
                    $insert_drug->execute || $logger->error($insert_drug->errstr);
                    print DRUGFILE $disch_sum_results{'subject_id'} . "\t" . $disch_sum_results{'hadm_id'} . "\t" . $type . "\t" . 'DIGOXIN' . "\t" . $drugname . "\n";
                }
            }
        }
    }

#    write_drug_file(\%disch_sum_results);
}

close DRUGFILE;
