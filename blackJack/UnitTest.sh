target="blackJack"
destination="platform=macOS, name=Any Mac"

start_time=`date +%s`

schemaList=(`xcodebuild -list | sed -n '/Scheme/,$p' | tail -n +2`)
failedSchemaList=()
succeededSchemaList=()

# build
xcodebuild  -scheme blackJack  -target blackJack -clonedSourcePackagesDirPath ".SPM"
# test
xcodebuild  -scheme test -target blackJack  test -clonedSourcePackagesDirPath ".SPM"

end_time=`date +%s`


run_time=$((end_time - start_time))
echo $run_time