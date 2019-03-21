const cote = require('cote');
const mysql = require('mysql');
const stringSimilarity = require('string-similarity');
const fs = require("fs");
const appRoot = require('app-root-path');



const mc = mysql.createPool({
    connectionLimit : 50,
    host: '127.0.0.1',
    user: 'root',
    password: '25791998',
    database: 'rezervator'
});

const dbService  = new cote.Responder({ name: 'Database Service', key: 'db', });

dbService.on('db-save-ocr-code', (req, cb) => {
    console.log("Saving ocr analysis code into db");
    mc.query("INSERT INTO ocrResult(`user_id`, `ocr_result_id`, `started`) VALUES (?, ?, now());", [req.user, req.code], function (error, results, fields) {
        console.log(`ukládám info o požadavku ${req.code}`);
        let result = results.insertId;
        cb(result);
    });
});

dbService.on('db-save-downloaded-ocr', (req, cb) => {
    console.log("Saving finished ocr analysis into db");
    mc.query(`UPDATE ocrResult SET finished = now(), ocr_parsed_data = ? WHERE id = ?;`, [req.json, req.insertedId], function (error, results, fields) {
        console.log(`ukládám požadavku ${req.insertedId}`);
        let uDetail = JSON.parse(req.json).result;
        let documentDataQuery = `INSERT INTO documentData(confidence, driving_license_expiration, driving_license_issued, driving_license_number, id_expiration, id_issued, id_mrz_valid, id_number) VALUES (?, STR_TO_DATE(?, '%d.%m.%Y'), STR_TO_DATE(?, '%d.%m.%Y'), ?, STR_TO_DATE(?, '%d.%m.%Y'), STR_TO_DATE(?, '%d.%m.%Y'), ?, ?);`;
        mc.query(documentDataQuery, [uDetail.confidence, uDetail.driving_license_expiration, uDetail.driving_license_issued, uDetail.driving_license_number, uDetail.id_expiration, uDetail.id_issued, uDetail.id_mrz_valid, uDetail.id_number], function (error, results, fields) {

            console.log(error);
            console.log(results);

            let userDataQuery = `INSERT INTO userDetail(name, surname, personal_number, sex, academic_title, address_city, address_city_part, address_district, address_number, address_street, birthday, birthplace, birthplace_district, document_data, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, STR_TO_DATE(?, '%d.%m.%Y'), ?, ?, ?, ?);`;
            mc.query(userDataQuery, [uDetail.name, uDetail.surname, uDetail.personal_number, uDetail.sex, uDetail.academic_title, uDetail.address_city, uDetail.address_city_part, uDetail.address_district, uDetail.address_number, uDetail.address_street, uDetail.birthday, uDetail.birthplace, uDetail.birthplace_district, results.insertId, req.user], function (error, results, fields) {
                console.log(error);
                console.log(results);
                cb(results.insertId);
            });

        });
    });
});

dbService.on('db-calculate-confidence', (req, cb) => {

    mc.query("select * from userDetail where user_id = ? order by created_at desc", [req.user.id], function (error, results, fields) {

        console.log(`Porovnávám jména: ${req.user.displayName} a ${results[0].name} ${results[0].surname}`);
        let similarity = stringSimilarity.compareTwoStrings(req.user.displayName.toLowerCase(), `${results[0].name} ${results[0].surname}`.toLowerCase());
        console.log(`podobnost je: ${similarity} bude udělen počet bodů: ${similarity*10*3}`);
        mc.query("UPDATE users SET confidence = ? WHERE id = ?;", [similarity*10*3, req.user.id], function (error, results, fields) {
            let result = results.insertId;
            cb(result);
        });

    });

});
