# mysql-extension

基于[mysql](https://github.com/felixge/node-mysql)的扩展，在它的基础上完成Prepared statements

## 安装

```bash
npm install mysql-extension
```

## 使用

```js
var mysql      = require('mysql-extension');
var db = mysql.createConnection({
  host     : 'example.org',
  user     : 'bob',
  password : 'secret'
});

db.query('SELECT name FROM T1 WHERE id = "042129"', function (err, info) {
	
});

var sql = 'SELECT name FROM T1 WHERE id = :id';
var params = { id: '042129' };

db.query({sql: sql, params: params}, function (err, info) {
	
});
```
