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

package svx.parse;

import svx.Main;
import svx.utilities.Severity;

/**
 * The ParseSVVersion class extends from ParseNode, and is used for containing the required file header line.
 * 
 * @author sfhoover
 *
 */
public class ParseSVXVersion extends ParseNode
{
	public static final String mnemonicStr = "\\SVX_version";
	public static final String requiredFileHeader = mnemonicStr + " 0.1: https://mmdc-wiki.hd.intel.com/wiki/bin/edit.cgi/MMDCArch/SvxMain";

	public ParseSVXVersion(ParseNode source_node)
	{
		super(source_node);
		setType(NodeType.SVX_VERSION);
	}
	
	public ParseSVXVersion(ParseBranch parent_branch, ParseNode source_node)
	{
		super(parent_branch, source_node);
		setType(NodeType.SVX_VERSION);
		
		// Check this node text.
		if (!stringWithoutIndentation.startsWith(requiredFileHeader))
		{
			ActiveParseContext.Report(0, Severity.WARNING, "BAD-HEADER", mnemonicStr + " node does not contain the correct text.  It must be (precisely):\n\t\"" +
		                    requiredFileHeader + "\"but it is instead:\n\t\"" + stringWithoutIndentation + "\"");
		}
		if (indentation != 0)
		{
			ActiveParseContext.Report(0, Severity.FATAL_ERROR, "INDENTATION", mnemonicStr + " has indentation of " + indentation +
					   ".  This type should not be indented (and should be the first line of the file).");
		}
		
		// Set stringSV.
		stringSV = (Main.command_line_options.noLine() ? "" :
				       "`line 2 \"" + ((SourceFile)(this.getParseBranch_ofType(NodeType.FILE))).getSvxFile().getName() + "\"") +
				   "// " + stringWithoutIndentation;
	}
}
