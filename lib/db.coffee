# /*!
#  * common/db.coffee, db client
#  * Copyright(c) 2013
#  * Author: jifeng.zjd <jifeng.zjd@alibaba-inc.com>
#  */


events      = require 'events'
os          = require 'options-stream'
mysql       = require 'mysql'

class DB extends events.EventEmitter
  constructor : (@args) ->
    @options = os {
      host     : 'localhost',
      user     : 'me',
      password : 'secret'
    }, @args
    # @connection = mysql.createConnection @options
    # @connection.connect()
    @pool = mysql.createPool @options

  
  query: (params, cb)->
    params = params || {}
    sql = undefined
    #单纯的sql语句
    if 'string' is typeof params
      sql = params
    else if params.sql and params.params
      sql = params.sql
      for k, v of params.params
        if 'string' is typeof v or 'number' is typeof v
          sql = sql.replace ":#{k}", @pool.escape(v)
        else if Array.isArray v
          sql = sql.replace ":#{k}", "( #{@connection.escape(v)} )"
    return cb new Error("Invalid params #{JSON.stringify(params)}") if !sql
    #从连接池中获取连接
    @pool.getConnection (err, conn)->
      return cb err if err
      conn.query sql, (err, row) ->
        conn.release() # 释放连接
        return cb(err, row) if !err
        err.sql = sql
        err.params = JSON.stringify params
        cb err, row

  close : (cb) ->
    # @connection.end()
    cb()

module.exports = (args)->
  new DB args