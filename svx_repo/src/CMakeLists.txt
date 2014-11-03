
add_subdirectory(joptsimple)
add_subdirectory(svx)



add_jar(svxpp AppLauncher.java) 

add_dependencies(svxpp svx)

add_custom_command(TARGET svxpp 
	POST_BUILD 
	COMMAND jar ufe svxpp.jar AppLauncher
	COMMAND jar uf svxpp.jar -C ${SVXPP_BUILD_DIR}/joptsimple joptsimple.jar 
	COMMAND jar uf svxpp.jar -C ${SVXPP_BUILD_DIR}/svx svx.jar
	)


install_jar(svxpp ${SVXPP_TARGET_DIR})

#set(SVXPP_SRC
#	svx/Main.java
#	svx/behavioral/Alignment.java
#	svx/behavioral/LogicalBehHier.java
#	svx/behavioral/LogicalBehScope.java
#	svx/behavioral/LogicalBranch.java
#	svx/behavioral/LogicalNode.java
#	svx/behavioral/LogicalPipeline.java
#	svx/behavioral/LogicalStage.java
#	svx/behavioral/LogicalWhen.java
#	svx/behavioral/PipeSignal.java
#	svx/behavioral/TransitionStage.java
#	svx/behavioral/range/AssignedBitRange.java
#	svx/behavioral/range/BitRange.java
#	svx/behavioral/range/Range.java
#	svx/behavioral/range/TransitionRange.java
#	svx/behavioral/range/UsedBitRange.java
#	svx/config/IdentifierType.java
#	svx/config/ProjSpecific.java
#	svx/parse/Assignment.java
#	svx/parse/NodeType.java
#	svx/parse/ParseBehHier.java
#	svx/parse/ParseBehScope.java
#	svx/parse/ParseBranch.java
#	svx/parse/ParseContext.java
#	svx/parse/ParseNode.java
#	svx/parse/ParsePipeline.java
#	svx/parse/ParseSV.java
#	svx/parse/ParseSVX.java
#	svx/parse/ParseSVXVersion.java
#	svx/parse/ParseStage.java
#	svx/parse/ParseWhen.java
#	svx/parse/Prefix.java
#	svx/parse/SourceFile.java
#	svx/parse/identifier/Expression.java
#	svx/parse/identifier/Identifier.java
#	svx/parse/identifier/ParseElement.java
#	svx/parse/identifier/ParseMnemonic.java
#	svx/utilities/Severity.java
#)
#
#set(JOPTSIMPLE_SRC 
#	joptsimple/AbstractOptionSpec.java
#	joptsimple/AlternativeLongOptionSpec.java
#	joptsimple/ArgumentAcceptingOptionSpec.java
#	joptsimple/ArgumentList.java
#	joptsimple/BuiltinHelpFormatter.java
#	joptsimple/HelpFormatter.java
#	joptsimple/IllegalOptionSpecificationException.java
#	joptsimple/MissingRequiredOptionException.java
#	joptsimple/MultipleArgumentsForOptionException.java
#	joptsimple/NoArgumentOptionSpec.java
#	joptsimple/OptionArgumentConversionException.java
#	joptsimple/OptionDescriptor.java
#	joptsimple/OptionException.java
#	joptsimple/OptionMissingRequiredArgumentException.java
#	joptsimple/OptionParser.java
#	joptsimple/OptionParserState.java
#	joptsimple/OptionSet.java
#	joptsimple/OptionSpec.java
#	joptsimple/OptionSpecBuilder.java
#	joptsimple/OptionSpecTokenizer.java
#	joptsimple/OptionalArgumentOptionSpec.java
#	joptsimple/ParserRules.java
#	joptsimple/RequiredArgumentOptionSpec.java
#	joptsimple/UnrecognizedOptionException.java
#	joptsimple/ValueConversionException.java
#	joptsimple/ValueConverter.java
#	joptsimple/internal/AbbreviationMap.java
#	joptsimple/internal/Classes.java
#	joptsimple/internal/Column.java
#	joptsimple/internal/ColumnWidthCalculator.java
#	joptsimple/internal/ColumnarData.java
#	joptsimple/internal/ConstructorInvokingValueConverter.java
#	joptsimple/internal/MethodInvokingValueConverter.java
#	joptsimple/internal/Objects.java
#	joptsimple/internal/Reflection.java
#	joptsimple/internal/ReflectionException.java
#	joptsimple/internal/Strings.java
#	joptsimple/util/DateConverter.java
#	joptsimple/util/KeyValuePair.java
#	joptsimple/util/RegexMatcher.java)
#
##set(CMAKE_JAVA_JAR_ENTRY_POINT svx/Main) # this only works for cmake 2.8.8
#set(CMAKE_JAVA_TARGET_OUTPUT_DIR {$SVXPP_TARGET_DIR})
#add_jar(svxpp ${JOPTSIMPLE_SRX} ${SVXPP_SRC})
#
#add_custom_command(TARGET svxpp POST_BUILD COMMAND jar ufe svxpp.jar svx.Main)
#
#install_jar(svxpp ${SVXPP_TARGET_DIR})
