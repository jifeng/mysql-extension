# /*!
#  * tests/common/test-db.coffee, db 单元测试
#  * Copyright(c) 2014
#  * Author: jifeng.zjd <jifeng.zjd@alibaba-inc.com>
#  */


e           = require 'expect.js'
DB          = require '../lib/db'

describe 'db', ()->
  db = DB()
  _query = db.connection.query
  before (done)->
    db.connection.query = (sql, cb)->
      process.nextTick ()->
        cb undefined, sql
    done()

  after (done)->
    db.connection.query = _query
    db.close done

  it 'query sql success', (done)->
    sql = 'SELECT name FROM T1 WHERE id = "042129"'
    db.query sql, (err, info)->
      e(err).to.eql(undefined)
      e(info).to.eql(sql)
      done()

  it 'query fail invalid sql', (done)->
    sql = undefined
    db.query sql, (err, info)->
      e(err.message).to.contain('Invalid params {}')
      done()

  it 'query sql and params success', (done)->
    sql = 'SELECT name FROM T1 WHERE id = :id'
    params = { id: '042129' }
    db.query {sql: sql, params: params}, (err, info)->
      e(err).to.eql(undefined)
      e(info).to.eql('SELECT name FROM T1 WHERE id = 042129')
      done()

  it 'query fail when err happen', (done)->
    sql = 'SELECT name FROM T1 WHERE id = :id'
    params = { id: '042129' }
    _query = db.connection.query
    db.connection.query = (err, cb)->
      process.nextTick ()->
        cb new Error 'mock err'
    db.query {sql: sql, params: params}, (err, info)->
      e(err.message).to.eql('mock err')
      e(err.sql).to.eql('SELECT name FROM T1 WHERE id = 042129')
      e(err.params).to.eql('{"sql":"SELECT name FROM T1 WHERE id = :id","params":{"id":"042129"}}')
      db.connection.query = _query
      done()
