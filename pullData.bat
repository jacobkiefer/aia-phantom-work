@echo off
setlocal EnableDelayedExpansion

rem Set AWS configuration
aws configure set aws_access_key_id 7b8d31d9d2f2d73ffb2208614db599fa
aws configure set aws_secret_access_key 8bd955340e355418a5204e52a055005b6ca761f896abe0cccdd741638e790a76
aws configure set region auto
aws configure set output json

set myPath=.\test_data
set myEndPoint=https://6ff2cd7dae70306649e2c1e1500e2e0a.r2.cloudflarestorage.com
set awsDataPathPrefix=s3://adsbx-sample-data/readsb-hist/2025/01/01/
set awsDataPathPostfix=Z.json.gz

rem loop through every hour (00 to 23)
for /L %%H in (0,1,23) do (
    rem loop through every minute (00 to 59)
    for /L %%M in (0,1,59) do (
        rem loop through every 5 seconds (00, 05, ..., 55)
        for /L %%S in (0,5,55) do (
            rem Pad single-digit values with a leading zero for formatting
            if %%H LEQ 9 (set hour=0%%H) else (set hour=%%H)
            if %%M LEQ 9 (set min=0%%M) else (set min=%%M)
            if %%S LEQ 5 (set sec=0%%S) else (set sec=%%S)
           
            rem Display the formatted Zulu time
            echo !hour!!min!!sec!Z
            if exist !myPath!\!hour!!min!!sec!!awsDataPathPostfix! (
                echo file exists already
            ) else (
                echo pulling data file
                set awsDataPath=!awsDataPathPrefix!!hour!!min!!sec!!awsDataPathPostfix!
                rem echo aws s3 cp !awsDataPath! %myPath% --endpoint-url %myEndPoint%
                aws s3 cp !awsDataPath! %myPath% --endpoint-url %myEndPoint%
            )

            
            rem Pause for 5 seconds, suppressing the timeout countdown
            rem timeout /t 5 /nobreak >nul
        )
    )
)
rem Example AWS CLI command to list directories of adsbexchange.com sample data, using the default profile and configureation above
rem aws s3 ls s3://adsbx-sample-data/readsb-hist/  --endpoint-url https://6ff2cd7dae70306649e2c1e1500e2e0a.r2.cloudflarestorage.com

rem aws s3 cp s3://adsbx-sample-data/readsb-hist/2025/01/01/000005Z.json.gz .\test_data --endpoint-url https://6ff2cd7dae70306649e2c1e1500e2e0a.r2.cloudflarestorage.com



