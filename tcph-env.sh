export DBUSER=root;
export DBURI='jdbc:mysql://localhost?useSSL=false';
export DBPASSWORD=root;
export DBHOST=localhost;
export DBSLOWLOG=/var/lib/mysql/ubuntu-slow.log;
export DBGENERALLOG=/var/lib/mysql/ubuntu.log;
export BENCHMARK='tpch';
export CONFIG='sample_tpch_config.xml';
export DB='tpch';
export RUNID='mysql-3min';
export KEYPREFIX="$BENCHMARK-$RUNID";
export RESULT_DIR="./results/tpch"
export CURRENT_USER=`whoami`;

mkdir -p $RESULT_DIR

mysql -h $DBHOST --user=$DBUSER --password=$DBPASSWORD < ./mysql/disable_logs.sql;

mysqladmin drop $DB -h $DBHOST --user=$DBUSER --password=$DBPASSWORD;
mysqladmin create $DB -h $DBHOST --user=$DBUSER --password=$DBPASSWORD;

./oltpbenchmark -b $DB -c config/$CONFIG --create=true;
./oltpbenchmark -b $DB -c config/$CONFIG --load=true;

mysqldump -h $DBHOST --user=$DBUSER --password=$DBPASSWORD --databases $DB \
--skip-lock-tables \
--no-data --result-file="$RESULT_DIR/${KEYPREFIX}-create.sql";

mysqldump -h $DBHOST --user=$DBUSER --password=$DBPASSWORD --databases $DB \
 --skip-lock-tables \
 --no-create-info --result-file="$RESULT_DIR/${KEYPREFIX}-data.sql";

rm -f $DBSLOWLOG;
rm -f $DBGENERALLOG;

mysql -h $DBHOST --user=$DBUSER --password=$DBPASSWORD < ./mysql/enable_logs.sql;

mysqladmin flush-logs -h $DBHOST --user=$DBUSER --password=$DBPASSWORD;

./oltpbenchmark -b $DB -c config/$CONFIG --execute=true;

mysql -h $DBHOST --user=$DBUSER --password=$DBPASSWORD < ./mysql/disable_logs.sql;

sudo cp $DBGENERALLOG "$RESULT_DIR/$KEYPREFIX-general.log";
sudo cp $DBSLOWLOG "$RESULT_DIR/$KEYPREFIX-slow.log";
sudo chmod 777 "$RESULT_DIR/$KEYPREFIX-slow.log";
sudo chmod 777 "$RESULT_DIR/$KEYPREFIX-general.log";
sudo chown "$CURRENT_USER:$CURRENT_USER" "$RESULT_DIR/$KEYPREFIX-general.log";
sudo chown "$CURRENT_USER:$CURRENT_USER" "$RESULT_DIR/$KEYPREFIX-slow.log";

# Run dart-cli to extract the information with and without log
dart-cli -i $DB --uri $DBURI -u $DBUSER -p $DBPASSWORD --vendor mysql --output json -o "$RESULT_DIR/$KEYPREFIX-implicit-only.json" --exclude-implicit-schema
dart-cli -i $DB --uri $DBURI -u $DBUSER -p $DBPASSWORD --vendor mysql --output json -o "$RESULT_DIR/$KEYPREFIX-explicit-only.json" --mysql-general-log-file "$RESULT_DIR/$KEYPREFIX-general.log" --exclude-explicit-schema