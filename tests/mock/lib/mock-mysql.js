/*!
 * mysql 的模拟
 * dxpweb - test/mock/lib/mock-mysql.js
 * Copyright(c) 2013 Taobao.com
 * Author: jifeng.zjd <jifeng.zjd@taobao.com>
 */

var connection = {
  connect: function () {},
  query: function (sql, cb) {
    process.nextTick(function () {
      cb(undefined, sql)
    });
  },
  escape: function (id) {
    return id;
  },
  end: function () {},
  release: function () {}
}

exports.mock = function () {
  require('mysql');
  require.cache[require.resolve("mysql")].exports = {
    createConnection : function () {
      return connection;
    },
    createPool: function () {
      var pool = {
        getConnection: function (cb) {
          process.nextTick(function () {
            cb(undefined, connection)
          });
        },
        escape: function (id) {
          return id;
        }
      }
      return pool;
    }
  };
}
exports.unmock  = function () {
  delete require.cache[require.resolve("mysql")];
}
