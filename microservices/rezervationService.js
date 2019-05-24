require('dotenv').config();
const Log = require('./log.js');
const logger = new Log('rezervationService');

const cote = require('cote');
const Sequelize = require('sequelize');

const sequelize = new Sequelize('rezervator', 'root', process.env.MYSQL_PASS, {
    host: process.env.MYSQL_HOST,
    dialect:'mysql',
    pool: {
        max: 50,
        min: 1,
        acquire: 30000,
        idle: 10000
    }
});

let rentsDefinition = require('../models/rents.js');
let Rent = rentsDefinition(sequelize, Sequelize);

const rezervationService  = new cote.Responder({ name: 'Rezervation Service', key: 'rezervation', });

rezervationService.on('list-cars-from-date-for-time', (req, cb) => {
    Rent.findAll().then(rents => {
        cb(rents);
    });
});

rezervationService.on('rezerve-car-from-date-for-time', (req, cb) => {

});

rezervationService.on('calculate-price-from-rezerve', (req, cb) => {
    logger.info(`Starting calculation for reservationId=${req.reservationId}`);
});