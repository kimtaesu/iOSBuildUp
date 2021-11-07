#!/bin/bash
echo Generating iOSBuildUp

projects=( 
	# Frameworks
	"App"
	)

for value in "${projects[@]}"; do
    xcodegen --spec $value/project.yml --project $value
    echo "xcodegen --spec $value/project.yml --project $value" 
done

