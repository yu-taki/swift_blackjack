target="blackJack"
destination="platform=macOS, name=Any Mac"

start_time=`date +%s`

schemaList=(`xcodebuild -list | sed -n '/Scheme/,$p' | tail -n +2`)
failedSchemaList=()
succeededSchemaList=()
for scheme in "${schemaList[@]}" ;do
    echo "TestStart ${scheme}"
    xcodebuild  -scheme $scheme -target $target  build
    if [ $? -ne 0 ]; then
      failedSchemaList+="$scheme\n"
    else
      succeededSchemaList+="$scheme\n"
    fi
done

echo "テストが失敗したPackage"
echo $failedSchemaList

echo "テストが成功したPackage"
echo $succeededSchemaList

end_time=`date +%s`


run_time=$((end_time - start_time))
echo $run_time