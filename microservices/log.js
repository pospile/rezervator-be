const Logger = require('logdna');
const os = require('os');
const chalk = require('chalk');

function Log(service) {

    if (!(this instanceof Log)) {
        return new Log(service);
    }

    let options = {
        hostname: os.hostname(),
        app: service,
        env: process.env.ENVIROMENT
    };

    // Defaults to false, when true ensures meta object will be searchable
    options.index_meta = true;

    // Define a singleton instance
    let logger = Logger.setupDefaultLogger(process.env.LOG_KEY, options);


    this.logger = logger;
};

Log.prototype.info = function info(message, options) {
    console.log(`${chalk.white(message)}`);
    this.logger.info(message, options);
};

Log.prototype.warn = function warn(message, options) {
    console.log(`${chalk.yellow(message)}`);
    this.logger.warn(message, options);
};

Log.prototype.error = function error(message, options) {
    console.log(`${chalk.red(message)}`);
    this.logger.error(message, options);
};

module.exports = Log;