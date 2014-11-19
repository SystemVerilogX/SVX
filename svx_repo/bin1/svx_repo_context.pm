
# Copyright (c) 2014, Intel Corporation
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Intel Corporation nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


package Context;

use strict;

use FindBin ();



#
# Configuration
#

my $expected_java = '/usr/intel/pkgs/java/1.7.0.02/bin/java';
my $expected_cmake = '/usr/intel/pkgs/cmake/2.8.7/bin/cmake';

# This structure is used to characterize the examples and define regression tests.
# TODO: I took the wrong approach with this.  Build/run of examples should be
#       considered build, not regression.  Need to rework this whole build
#       infrastructure w/ cmake.
  # If these are touched, rebuild everything:
@Context::lib_files = ('m4/generic.vxm4',
                       'm4/pipeflow_lib.vxm4',
                       'target/svxpp.jar',
                       'proprietary/examples/aes/hdl/soc_clocks.sv',
                       'proprietary/examples/aes/hdl/soc_macros.sv',
                       'proprietary/examples/rsa/rtl/soc_clocks.sv',
                       'proprietary/examples/rsa/rtl/soc_macros.sv');
#my $aplr_repo = (exists $ENV{APLR_REPO}) ? $ENV{APLR_REPO} : "<UNDEFINED>";
%Context::tests = (
  beh_hier           => {vx => ['examples/beh_hier/beh_hier.vx'],
                         exit_code => [4]
                        },
  users_guide1       => {vx => ['examples/doc_examples/users_guide1.vx'],
                         exit_code => [4]
                        },
  operand_mux        => {vx => ['examples/dttc_2012/operand3.vx',
                                'examples/dttc_2012/operand4.vx'],
                         exit_code => [4, 4]
                        },
  slide_example      => {vx => ['examples/slide_example/slide_example.vx'],
                         exit_code => [4]
                        },
  yuras_presentation => {vx => ['examples/yuras_presentation/yuras_presentation.vx']},
  aes_dec_top        => {vx => ['proprietary/examples/aes/hdl/aes_dec_top.vx',
                                'proprietary/examples/aes/hdl/aes_dec_10.vx',
                                'proprietary/examples/aes/hdl/aes_dec_10_xinj.vxm4'],
                         pp_args => ['', '', " --xinj --xclk"],
                         f  => ['proprietary/examples/aes/hdl/aes_dec_top.f',
                                'proprietary/examples/aes/hdl/aes_dec_top_xinj.f'],
                         subdir => ['no_xinj', 'xinj']},
                         # dump => ['aes_dec_top.dump', 'aes_dec_top.dump']},
                         # simv => 1},  # Just run, no check.
  rsa                => {vx => ['proprietary/examples/rsa/rtl/eau_top.vxm4'],
                         pp_args => [' --xinj --xclk'],
                         f  => ['proprietary/examples/rsa/rtl/eau_top.f'],
                         simv => 2  # Self-checking.
                        },
  hahitmectls        => {vx => ['proprietary/examples/hahitmectls/hahitmectls.vx']},
  hascheds           => {vx => ['proprietary/examples/ivx_hascheds/hascheds_baseline.vx'],
                         exit_code => [4]
                        },
  shifter            => {vx => ['proprietary/examples/shifter/shifter.vx'],
                         exit_code => [1]
                        },
  #oqi_pipe           => {vx => ['proprietary/examples/skx_iio/oqi_pipe.vx']},
  tracker            => {vx => ['proprietary/examples/gpr_tracker/tracker.vx']},
  ring               => {vx => ['examples/ring/ring.vxm4',
                                'examples/ring/ring_tb.vx'],
                         pp_args => [" --xinj --xclk", " --xinj --xclk"],
                         exit_code => [0, 0],
                         f => ['examples/ring/ring.f'],
                         simv => 2  # Self-checking.
                        },

  #
  # These are source controlled elsewhere, but can be run from this environment.
  # They are not part of the regression.
  #
  aplr               => {path_env => 'APLR_REPO',   # An environment variable that must exist to use this test and is used as an include path for m4.
                         # TODO: Need to expose aplr.m4 as a source file for dependence analysis.
                         vx => [# "src/subswitch.vx",
                                # "src/subswitch_tb.vx",
                                "src/aplr.vxm4",
                                "src/aplr_tb.vx"],
                         pp_args => [' -noline --xinj --xclk',
                                     ' -noline --xinj --xclk'],
                         exit_code => [0, 0],
                         f => ["src/aplr.f"]
                         #simv => 2  # Self-checking.
                        },

  instr_pipe         => {path_env => 'APLR_REPO',   # An environment variable that must exist to use this test and is used as an include path for m4.
                         # TODO: Need to expose aplr.m4 as a source file for dependence analysis.
                         vx => [#"src/subswitch.vx",
                                #"src/subswitch_tb.vx",
                                "src/instr_pipe.vxm4",
                                "src/instr_pipe_tb.vx"],
                         pp_args => [' -noline --xinj --xclk', " --xinj --xclk"],
                         exit_code => [1, 0],
                         f => [#"src/subswitch.f",
                               "src/instr_pipe.f"]
                         #simv => 2  # Self-checking.
                        }

#  instr_pipe         => {path_env => 'APLR_REPO',   # An environment variable that must exist to use this test and is used as an include path for m4.
#                         # TODO: Need to expose aplr.m4 as a source file for dependence analysis.
#                         vx => [#"src/subswitch.vx",
#                                #"src/subswitch_tb.vx",
#                                "src/instr_pipe.vxm4",
#                                "src/instr_pipe_tb.vx"],
#                         pp_args => [' -noline --xinj --xclk', " --xinj --xclk"],
#                         exit_code => [1, 0],
#                         f => [#"src/subswitch.f",
#                               "src/instr_pipe.f"]
#                         #simv => 2  # Self-checking.
#                        }
);



#
# Subroutines
#


# Init.
#   Chdir to repository dir.
#   Check Java version.
# Args:
#   bool: svxpp required
#   bool: (default 1) VCS required
sub init {
  my $svxpp_needed = shift;
  my $vcs_required = shift;
  if (!defined($vcs_required)) {$vcs_required = 1;}

  $ENV{VCS_HOME} = '/p/com/eda/synopsys/vcsmx/D-2009.12-12';
  if (!-e $ENV{VCS_HOME}) {
    # Different path in Hudson.
    $ENV{VCS_HOME} = '/p/hsx/rtl/cad/x86-64_linux26/synopsys/vcs/D-2009.12-12';
    ((-e $ENV{VCS_HOME}) || !$vcs_required) or die "Can't find VCS";
  }
  $ENV{SNPSLMD_LICENSE_FILE} = '26586@fmylic38b.fm.intel.com:26586@fmylic38c.fm.intel.com:26586@ilic1022.iil.intel.com:26586@hdylic09.hd.intel.com:26586@fmylic36c.fm.intel.com:26586@plxs0414.pdx.intel.com:26586@plxs0415.pdx.intel.com:26586@plxs0402.pdx.intel.com:26586@plxs0406.pdx.intel.com:26586@scylic14.sc.intel.com:26586@scylic15.sc.intel.com';

  # Check environment.
  $Context::java = `which java`;
  chomp $Context::java;
  if ($Context::java ne $expected_java) {
    print "\nWarning: Expecting \$PATH to find java at: '$expected_java', not '$Context::java'\n\n";
  }
  $Context::cmake = `which cmake`;
  chomp $Context::cmake;
  if ($Context::cmake ne $expected_cmake) {
    print "\nWarning: Expecting \$PATH to find cmake at: '$expected_cmake', not '$Context::cmake'\n\n";
  }


  # cd into repo dir.

  my $bin_dir = $FindBin::Bin;

  # Get the path to this executable (which is in bin dir).
  chdir $bin_dir or die "Couldn't cd to bin dir: $bin_dir.";

  # Validate dir.
  $bin_dir = `pwd`;
  chomp $bin_dir;
  my $dir = $bin_dir;
  ($dir =~ s|/bin$||) or die "Bug: /bin dir $dir doesn't look right.";

  # cd to requested dir (from /bin dir).
  chdir $dir or die "Couldn't chdir: $dir.";

  $Context::repo_dir = $dir;


  # Check for svxpp.
  if ($svxpp_needed) {
    # Make sure SVXpp exists.
    (-e "target/svxpp.jar") or die "SVXpp has not been built.";
  }
}


# Get a test.
# Returns the structure from %Context::tests.
sub get_test {
  my $test_name = shift;
  if (!exists $Context::tests{$test_name}) { 
    print STDERR "Invalid test name: $test_name.\n";
    print STDERR "Recognized test names are:\n";
    foreach my $test (keys %Context::tests) {
      print STDERR "\t$test\n";
    }
    exit(2);
  }
  my $test_ref = $Context::tests{$test_name};
  if ( exists $$test_ref{path_env} &&
      !exists $ENV{$$test_ref{path_env}}) {
    print STDERR "Test $test_name cannot be accessed because environment variable $$test_ref{path_env} is not defined.\n";
    exit(2);
  }

  $Context::tests{$test_name};
}

# Make a directory if it doesn't already exist.
sub require_dir {
  my $dir = shift;
  mkdir $dir or (-e $dir) or die "Couldn't mkdir $dir";
}



1;
