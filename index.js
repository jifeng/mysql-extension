if (require.extensions['.coffee']) {
  module.exports = require('./lib/db.coffee');
} else {
  module.exports = require('./out/release/lib/db.js');
}
