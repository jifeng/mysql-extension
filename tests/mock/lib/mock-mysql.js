/*!
 * mysql 的模拟
 * dxpweb - test/mock/lib/mock-mysql.js
 * Copyright(c) 2013 Taobao.com
 * Author: jifeng.zjd <jifeng.zjd@taobao.com>
 */

exports.mock = function () {
  require('mysql');
  require.cache[require.resolve("mysql")].exports = {
    createConnection : function () {
      var connection = {
        connect: function () {},
        query: function (sql, cb) {
          process.nextTick(function () {
            cb()
          });
        },
        escape: function (id) {
          return id;
        },
        end: function () {}
      }
      return connection;
    }
  };
}
exports.unmock  = function () {
  delete require.cache[require.resolve("mysql")];
}
