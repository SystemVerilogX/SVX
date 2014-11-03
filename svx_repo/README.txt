/*
Copyright (c) 2014, Intel Corporation

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Intel Corporation nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/



Documentation can be found at https://mmdc-wiki.hd.intel.com/wiki/bin/view.cgi/MMDCArch/SvxInnovationTeam.

Here is a reference:


Build:
-----

In {local-clone-dir}
  > make_all
(which does):
  > /usr/intel/pkgs/cmake/2.8.7/bin/cmake . 
  > make 
  > make install 


Test:
----

In {local-clone-dir}
  > ctest -R <test-name>

Log written to ./Testing/Temporary/LastTest.log

Tests are defined in ./regression/CMakeLists.txt
They either run ./bin/test_vx <test-name> or ./bin/run_vcs <test-name>, which pick up
  where make_all leaves off, and write output to "regress/gen/<test-name>".


Regression:
----------

In {local-clone-dir}
  > /usr/intel/pkgs/cmake/2.8.7/bin/ctest -j10  (10-way parallel)
  (Output written to "regress/gen".)
  > ./bin/diff_golden
  > git commit -m "message"
  > git pull
  > ./bin/certify_as_golden (if okay)
  > git commit -m "golden certification"
  > git push
