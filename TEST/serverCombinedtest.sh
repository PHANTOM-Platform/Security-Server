echo 'load two policies'
curl -G "http://127.0.0.1:8001/paapi/importpol" --data-urlencode "policyfile=EXAMPLES/policy_signals_access.pl"
curl -G "http://127.0.0.1:8001/paapi/importpol" --data-urlencode "policyfile=EXAMPLES/policy_vehicle_ownership.pl"
echo 'form combined policy'
curl -G "http://127.0.0.1:8001/paapi/combinepol" --data-urlencode "policy1=Signals Access Policy" --data-urlencode "policy2=Vehicle Ownership Policy" --data-urlencode "combined=Combined Policy"
echo 'set to Combined Policy'
curl -G "http://127.0.0.1:8001/paapi/setpol" --data-urlencode "policy=Combined Policy"
echo 'run nine test cases for Combined Policy'
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=r" --data-urlencode "object=VIN-1001 Door Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Sebastian" --data-urlencode "ar=r" --data-urlencode "object=VIN-1001 Door Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=r" --data-urlencode "object=VIN-3001 Shift Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=r" --data-urlencode "object=VIN-1001 Trip Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=r" --data-urlencode "object=VIN-3001 Trip Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=w" --data-urlencode "object=VIN-1001 Door Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=w" --data-urlencode "object=VIN-3001 Shift Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=w" --data-urlencode "object=VIN-1001 Trip Signals"
curl -G "http://127.0.0.1:8001/pqapi/access" --data-urlencode "user=Ana" --data-urlencode "ar=w" --data-urlencode "object=VIN-3001 Trip Signals"
echo end of Combined Policy curl tests
