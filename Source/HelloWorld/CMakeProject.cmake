include_directories(
	${HELLO_SKYLICHT_SOURCE_DIR}/Source/SampleFW
)

file(GLOB_RECURSE additional_source
	../SampleFW/**.cpp
	../SampleFW/**.h)
	
list (APPEND application_source ${additional_source})