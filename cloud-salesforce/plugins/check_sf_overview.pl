#!/usr/bin/perl -w
#
# Copyright (C) 2003-2018 Opsview Limited. All rights reserved
#  
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use lib '/opt/opsview/perl/lib/perl5';
use JSON;
use REST::Client;
use URI::Escape;
use WWW::Mechanize;
use Monitoring::Plugin;
use Getopt::Std;

my $script         = "check_sf_overview";
my $script_version = "1.0";

my $np = Monitoring::Plugin->new(
    usage =>
      "\n$script version $script_version\n \nThis plug in returns the status of the parameter from the 'System Overview' tab in Salesforce as specified from the user",
);

my $ua = LWP::UserAgent->new;
$ua->agent( "Opsview", )
  ; # tells the website what we are, usually a browser but opsview doesnt care
$ua->timeout(20);

#Arguments

$np->add_arg(
    spec => "mode|m=s",
    help =>
      "-m  |  --mode  =  For specifying the parameter that the user wants monitoring",
    required => 1,
);

$np->add_arg(
    spec => "username|u=s",
    help =>
      "-u  |  --username  =  For specifying the users salesforce username",
    required => 1,
);

$np->add_arg(
    spec => "password|p=s",
    help =>
      "-p  |  --password  =  For specifying the users salesforce password",
    required => 1,
);

$np->add_arg(
    spec => "token|T=s",
    help =>
      "-T  |  --token  =  For specifying the users salesforcetoken that goes on the end of the password",
    required => 1,
);

$np->add_arg(
    spec => "host_url|H=s",
    help => "-H  |  --host  =  For specifying the users salesforce host url",
    required => 1,
);

$np->add_arg(
    spec => "client_key|k=s",
    help =>
      "-k  |  --client_key  =  For specifying the users salesforce client key",
    required => 1,
);

$np->add_arg(
    spec => "client_secret|s=s",
    help =>
      "-s  |  --client_secret  =  For specifying the users salesforce client secret string",
    required => 1,
);

$np->add_arg(
    spec => "instance|i=s",
    help =>
      "-i  |  --instance  =  For specifying the users salesforce instance e.g. eu4",
    required => 1,
);

$np->add_arg(
    spec     => "warning|w=s",
    help     => "-w  |  --warning  =  For specifying the warning value",
    required => 1,
);

$np->add_arg(
    spec     => "critical|c=s",
    help     => "-c  |  --critical  =  For specifying the critical value",
    required => 1,
);

$np->getopts;

my $mode          = $np->opts->mode;
my $username      = $np->opts->username;
my $password      = $np->opts->password;
my $token         = $np->opts->token;
my $host_url      = $np->opts->host_url;
my $client_key    = $np->opts->client_key;
my $client_secret = $np->opts->client_secret;
my $instance      = $np->opts->instance;
my $warning       = $np->opts->warning;
my $critical      = $np->opts->critical;

if ( $mode eq "DailyApiRequests" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "DailyApiRequests", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Daily API Requests",
        "Daily API Requests",
        "API Requests"
    );
    $np->nagios_exit( OK, "$result remaining Daily API Requests" );
}

elsif ( $mode eq "HourlyTimeBasedWorkflow" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "HourlyTimeBasedWorkflow", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Hourly Time Based Workflow",
        "Hourly Time Based Workflow", "Hours"
    );
    $np->nagios_exit( OK, "$result remaining Hours" );
}

elsif ( $mode eq "DailyGenericStreamingApiEvents" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "DailyGenericStreamingApiEvents", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Daily Generic Streaming API Events",
        "Daily Generic Streaming API Events",
        "API Events"
    );
    $np->nagios_exit( OK,
        "$result remaining daily Generic Streaming API Events"
    );
}

elsif ( $mode eq "MassEmail" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "MassEmail", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result( $result, $warning, $critical, "Mass Emails", "Mass Emails",
        "Emails" );
    $np->nagios_exit( OK, "$result remaining Mass Emails" );
}

elsif ( $mode eq "ConcurrentSyncReportRuns" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "ConcurrentSyncReportRuns", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Concurrent Sync Report Runs",
        "Concurrent Sync Report Runs",
        "Report Runs"
    );
    $np->nagios_exit( OK, "$result remaining Concurrent Sync Report Runs" );
}

elsif ( $mode eq "DailyStreamingApiEvents" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "DailyStreamingApiEvents", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Daily Streaming API Events",
        "Daily Streaming API Events",
        "API Events"
    );
    $np->nagios_exit( OK, "$result remaining Daily Streaming API Events" );
}

elsif ( $mode eq "HourlySyncReportRuns" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "HourlySyncReportRuns", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Hourly Sync Report Runs",
        "Hourly Sync Report Runs",
        "Report Runs"
    );
    $np->nagios_exit( OK, "$result remaining Hourly Sync Report Runs" );
}

elsif ( $mode eq "DataStorageMB" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "DataStorageMB", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "remaing Data (in MB)",
        "Memory left in Data Storage", "MB"
    );
    $np->nagios_exit( OK, "$result remaining Data (in MB)" );
}

elsif ( $mode eq "DailyBulkApiRequests" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "DailyBulkApiRequests", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Daily Bulk API Requests",
        "Daily Bulk API Requests",
        "API Requests"
    );
    $np->nagios_exit( OK, "$result remaining Daily Bulk API Requests" );
}

elsif ( $mode eq "DailyAsyncApexExecutions" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "DailyAsyncApexExecutions", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Daily Async Apex Executions",
        "Daily Async Apex Executions", "Executions"
    );
    $np->nagios_exit( OK, "$result remaining Daily Async Apex Executions" );
}

elsif ( $mode eq "HourlyAsyncReportRuns" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "HourlyAsyncReportRuns", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Hourly Async Report Runs",
        "Hourly Async Report Runs",
        "Report Runs"
    );
    $np->nagios_exit( OK, "$result remaining Hourly Async Report Runs" );
}

elsif ( $mode eq "SingleEmail" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "SingleEmail", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Single Emails",
        "Single Emails", "Emails"
    );
    $np->nagios_exit( OK, "$result remaining Single Emails" );
}

elsif ( $mode eq "StreamingApiConcurrentClients" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "StreamingApiConcurrentClients", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Streaming API Concurrent Clients",
        "Streaming API Concurrent Clients", "Clients"
    );
    $np->nagios_exit( OK, "$result remaining Streaming API Concurrent Clients"
    );
}

elsif ( $mode eq "HourlyDashboardStatuses" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "HourlyDashboardStatuses", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Hourly Dashboard Statuses",
        "Hourly Dashboard Statuses", "Statuses"
    );
    $np->nagios_exit( OK, "$result remaining Hourly Dashboard Statuses" );
}

elsif ( $mode eq "ConcurrentAsyncGetReportInstances" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "ConcurrentAsyncGetReportInstances", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical, "Concurrent Async Get Report Instances",
        ,
        "Concurrent Async Get Report Instances",
        "Report Instances"
    );
    $np->nagios_exit( OK,
        "$result remaining Concurrent Async Get Report Instances"
    );
}

elsif ( $mode eq "HourlyDashboardResults" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "HourlyDashboardResults", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Hourly Dashboard Results",
        "Hourly Dashboard Results",
        "Hourly Dashboard Results"
    );
    $np->nagios_exit( OK, "$result remaining Hourly Dashboard Results" );
}

elsif ( $mode eq "DailyWorkflowEmails" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "DailyWorkflowEmails", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Daily Workflow Emails",
        "Daily Workflow Emails",
        "Workflow Emails"
    );
    $np->nagios_exit( OK, "$result remaining Daily Workflow Emails" );
}

elsif ( $mode eq "HourlyDashboardRefreshes" ) { #check
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = get_salesforce_data( $access_token, $instance );
    my @path = ( "HourlyDashboardRefreshes", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "Hourly Dashboard Refreshes",
        "Hourly Dashboard Refreshes",
        "Hourly Dashboard Refreshes"
    );
    $np->nagios_exit( OK, "$result remaining Hourly Dashboard Refreshes" );
}

elsif ( $mode eq "FileStorageMB" ) {
    my $access_token =
      salesforce_authentication( $host_url, $client_key, $client_secret,
        $token, $username, $password );
    my $json_object = eval { get_salesforce_data( $access_token, $instance ) };
    $np->nagios_die("Error: $@\n") if $@;
    my @path = ( "FileStorageMB", "Remaining" );
    my $result = decode_json_object( $json_object, \@path );
    check_result(
        $result, $warning, $critical,
        "File Storage (in MB)",
        "Memory left in File Storage", "MB"
    );
    $np->nagios_exit( OK, "$result remaining Memory left in File Storage" );
}

else {
    $np->nagios_die( "Input not recognised: " . $mode . "\n" );
}

sub check_result {
    my $result   = $_[0];
    my $warning  = $_[1];
    my $critical = $_[2];
    my $message  = $_[3];
    my $label    = $_[4];
    my $uom      = $_[5];
    $np->add_perfdata(
        label => $label,
        value => $result,
        uom   => " $uom",
    );

    if ( $result < $critical ) {
        $np->nagios_exit( "CRITICAL",
            "$result is below the $message value of $critical"
        );
    }
    elsif ( $result < $warning ) {
        $np->nagios_exit( "WARNING",
            "$result is below the $message value of $warning"
        );
    }
}

sub decode_json_object {
    my $json_ref = $_[0];
    my @path     = @{ $_[1] };

    #gets the value at the end of the path thats specified in the hash
    my $value = $json_ref->{ $path[0] }{ $path[1] };
    return $value;
}

sub salesforce_authentication {
    my ( $host_url, $client_key, $client_secret, $token, $username, $password )
      = @_;

    # Authenticate with SalesForce
    my $client = REST::Client->new();
    $client->setHost($host_url);
    $client->addHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
    $client->POST(
        '/services/oauth2/token',
        "grant_type=password"
          . "&client_id=$client_key"
          . "&client_secret=$client_secret"
          . "&username=$username"
          . "&password=$password$token"
    );

    # Decode as a JSON, die if error
    my $response = eval { decode_json( $client->responseContent ) };
    $np->nagios_die(
        "Error: $@\nCheck the following  parameters for possible cause for failure:\n-H  |  --host  input parameter"
    ) if $@;

    return $response->{'access_token'};

}

sub get_salesforce_data {
    my $data_access_token = $_[0]
      || $np->nagios_die(
        "Error: salesforce authentication failed, check input parameters."
      );
    my $instance = $_[1];
    my $mech     = WWW::Mechanize->new();
    $mech->agent( 'Mozilla/5.0' );
    $mech->add_header( "Authorization" => "Bearer " . $data_access_token );
    $mech->add_header(
        "X-PrettyPrint" => '1'
    );
    eval {
        $mech->get(
            "https://$instance.salesforce.com/services/data/v29.0/limits/"
        );
    };
    $np->nagios_die("Error: $@\n") if $@;
    my $data      = $mech->content;
    my $json      = JSON->new;
    my $json_data = $json->decode($data);
    return $json_data;
}
