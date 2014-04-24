var mysql = require('../');

var db = mysql({
	host: '127.0.0.1',
  user: 'user',
  password: 'password',
  database: 'database',
  port: 3306
});

db.query('SHOW TABLES;', function (err, info) {
  console.log(err, info);
});

