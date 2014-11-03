
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


# Regression suite.


# Preprocess and check results.
add_test(beh_hier           ${SVXPP_ROOT}/bin/test_vx beh_hier)
add_test(users_guide1       ${SVXPP_ROOT}/bin/test_vx users_guide1)
add_test(operand_mux        ${SVXPP_ROOT}/bin/test_vx operand_mux)
add_test(slide_example      ${SVXPP_ROOT}/bin/test_vx slide_example)
add_test(yuras_presentation ${SVXPP_ROOT}/bin/test_vx yuras_presentation)
#add_test(aes_dec_top        ${SVXPP_ROOT}/bin/test_vx aes_dec_top)
add_test(aes_dec_top        ${SVXPP_ROOT}/bin/run_vcs aes_dec_top)
add_test(rsa                ${SVXPP_ROOT}/bin/run_vcs rsa)
add_test(hahitmectls        ${SVXPP_ROOT}/bin/test_vx hahitmectls)
add_test(hascheds           ${SVXPP_ROOT}/bin/test_vx hascheds)
add_test(shifter            ${SVXPP_ROOT}/bin/test_vx shifter)
#add_test(oqi_pipe           ${SVXPP_ROOT}/bin/test_vx oqi_pipe)
add_test(tracker            ${SVXPP_ROOT}/bin/test_vx tracker)
add_test(ring               ${SVXPP_ROOT}/bin/run_vcs ring)
