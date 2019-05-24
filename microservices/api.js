require('dotenv').config();
const Log = require('./log.js');
const logger = new Log('apiService');

const path = require('path');
const fs = require('fs-extra');
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
let cookieParser = require('cookie-parser');
const mysql = require('mysql');
const braintree = require('braintree');
const appRoot = require('app-root-path');
const tokenizer = require('./jwt.js');
const URLs = require("./URLs.js").URLs;
const cote = require('cote');
const uuidv4 = require('uuid/v4');
const os = require('os');
const fileUpload = require("express-fileupload");
const useragent = require('express-useragent');

const ocrServiceRequester = new cote.Requester({ name: 'api service requester', key: 'ocr', });
const emailServiceRequester = new cote.Requester({ name: 'email service requester', key: 'email'});
const rezervationServiceRequester = new cote.Requester({ name: 'rezervation service requester', key: 'rezervation'});

app.use( bodyParser.json() );       // to support JSON-encoded bodies
app.use(cookieParser("secret-cookie"));
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
    extended: true
}));
app.use(fileUpload());
app.use(useragent.express());
app.use('/static', express.static(appRoot+'/microservices/public'));

console.log(`Loading logging service with api key ${process.env.LOG_KEY}`);


const POSITIVE_STATUSES = ["AUTHORIZED", "SETTLED", "SETTLING", "SUBMITTED_FOR_SETTLEMENT"];

let mc = mysql.createPool({
    connectionLimit : 50,
    host: process.env.MYSQL_HOST,
    user: 'root',
    password: process.env.MYSQL_PASS,
    database: 'rezervator'
});


const gateway = braintree.connect({
    environment: braintree.Environment.Sandbox,
    merchantId: 'p3f7n9z228533v47',
    publicKey: 'xncpxxc33bs3nbj3',
    privateKey: 'b967f843002a554cfcaf55429104f996'
});

app.use(function(req, res, next) {

    if (!req.cookies.uid) {
        req.uid = uuidv4();
        res.cookie('uid', req.uid);
    }

    req.loggingOptions = {"meta": {"url": req.originalUrl, "uid": req.uid, "user": req.cookies.id, "userAgentInfo": {"agent":req.useragent.browser, "browser":req.useragent.browser}, "cookies": req.cookies}}

    logger.info(`Request incoming`, req.loggingOptions);

    mc.query("select now() as time", [], function (err, data, val) {
        if (err) {
            req.loggingOptions.error = "db connection";
            logger.error(err, req.loggingOptions);
        }

        let skip = true;

        for (let key in URLs) {
            //TODO ořezat tu query params, takže se porovnává jen opravdová url
            if ( req.originalUrl === URLs[key].url ) {
                if ( URLs[key].auth ) {
                    skip = false;
                    if (req.cookies.auth == null || req.cookies.id == null || req.cookies.auth === "" || req.cookies.auth === undefined) {
                        logger.info(`Request is not authenticated`, req.loggingOptions);
                        res.status(403).json({"unauthorized": "please log-in to access this page"});
                        return;
                    }
                    mc.query("select * from users where id = ?", [req.cookies.id], function (error, results, fields) {
                        if (results) {
                            let verify = tokenizer.verify(req.cookies.auth, {
                                issuer: "Authorizaxtion/REZERVATOR/API.JS",
                                subject: results[0].email,
                                audience: results[0].scope // this should be provided by client
                            });
                            if ( verify && URLs[key].scope.includes(results[0].scope)) {
                                logger.info(`User is authenticated`, req.loggingOptions);
                                req.user = results[0];
                                next();
                            }
                            else {
                                logger.info(`Request is not authenticated`, req.loggingOptions);
                                res.status(403).json({"unauthorized": "please log-in to access this page", "service": os.hostname(), "time": Date.now()});
                                return;
                            }
                        }
                        else {
                            logger.info(`Request is not authenticated`, req.loggingOptions);
                            res.status(403).json({"unauthorized": "please log-in to access this page", "service": os.hostname(), "time": Date.now()});
                            return;
                        }
                    });
                }
            }
        }

        if (skip) {
            next();
        }

    });
});

app.get(URLs.ROOT.url, function (req, res) {
    return res.json({ error: false, message: 'This microservice is up and running' })
});

app.get(URLs.TRANSACTION_DETAIL.url, function (req, res) {
    mc.query(`select * from rents r left join transactions t on r.transaction = t.id where r.id = ${parseInt(req.params.rent_id)};`, function (error, results, fields) {
        return res.json({ error: false, 'transaction': results[0], 'rentId': req.params.rent_id})
    });
});

app.get(URLs.PAYMENT_UI.url, function (req, res) {
    mc.query(`select * from rents r left join transactions t on r.transaction = t.id where r.id = ${parseInt(req.params.rent_id)};`, function (error, results, fields) {
        if (results === undefined || results[0] === undefined) {
            return res.json({"error": true, "description": "This rent cannot be found"});
        }
        else if (results[0].status != null && POSITIVE_STATUSES.includes(results[0].status.toUpperCase())) {
            logger.info(`Transaction already payed`, req.loggingOptions);
            return res.sendFile(appRoot+'/microservices/view/transaction.html');
        }
        return res.sendFile(appRoot+'/microservices/view/payment.html');
    });
});

app.get(URLs.PAYMENT_API_INITIALIZE.url, function (req, res) {
    gateway.clientToken.generate({}, function (err, response) {
        return res.json({ error: false, 'clientToken':  response.clientToken, 'rentId': req.params.rent_id})
    });
});

app.post(URLs.PAYMENT_API_PROCESS.url, function (request, response) {

    let transaction = request.body;

    mc.query(`select u.* from users u inner join rents r on r.user = u.id where r.id =  ${parseInt(transaction.rent_id)};`, function (error, results, fields) {
        if (error) throw error;
        console.log(results);
        let customer = {};
        let attributes = {};
        let created;
        if (results[0].paymentId) {
            created = false;
            logger.info(`Creating transaction with paymentID=${results[0].paymentId}`, req.loggingOptions);
            attributes = {
                orderId: parseInt(transaction.rent_id),
                amount: 16.0,
                options: {
                    submitForSettlement: true
                },
                customerId: results[0].paymentId
            };
        }
        else {
            created = true;
            logger.info(`Creating transaction without paymentID setting paymentId=${results[0].uid}`, req.loggingOptions);
            customer = {
                lastName: results[0].displayName,
                email: results[0].email,
                id: results[0].uid,
            };
            attributes = {
                orderId: parseInt(transaction.rent_id),
                amount: transaction.amount,
                paymentMethodNonce: transaction.payment_method_nonce,
                options: {
                    submitForSettlement: true,
                    storeInVaultOnSuccess: true
                },
                customer: customer,
            };
        }
        gateway.transaction.sale(attributes, function (err, result) {

            if (err) throw err;

            if (result.success) {
                if (created) {
                    mc.query("UPDATE users SET paymentId = ? where uid = ?", [results[0].uid,results[0].uid], function (error, results, fields) {
                        if (error) throw error;
                    });
                }
                logger.info(`New transaction created Transaction=${[parseFloat(result.transaction.amount), 'positive', results[0].uid, result.transaction.currencyIsoCode, result.transaction.status]}`, req.loggingOptions);
                mc.query("INSERT INTO transactions(amount, type, extId, currency, status) VALUES (?, ?, ?, ?, ?)", [parseFloat(result.transaction.amount), 'positive', results[0].uid, result.transaction.currencyIsoCode, result.transaction.status], function (error, results, fields) {
                    if (error) throw error;

                    mc.query(`UPDATE rents SET transaction = ${results.insertId} where id = ${transaction.rent_id}`, function (error, results, fields) {
                        if (error) throw error;
                    });

                });

                //console.log(result.transaction);
                response.json({"error": false, "transaction": "done"});
            } else {
                logger.error(`Error in transaction result ${result}`, req.loggingOptions);
                response.json({"error": true, "transaction": "not_done"});
            }
        });
    });
});


app.get(URLs.TRANSACTIONS_FOR_NEXT_MONTH.url, function (req, res) {
    mc.query('SELECT * FROM rents WHERE date <= DATE_ADD(curdate(), INTERVAL 1 MONTH);', function (error, results, fields) {
        if (error) throw error;
        return res.json({ error: false, data: results });
    });
});

app.get(URLs.AVAILABILITY_FOR_DATE.url, function (req, res) {
    let date = req.params.date;

    if (!date) {
        return res.status(400).send({ error: true, message: 'Please provide date for availability' });
    }

    mc.query(`SELECT c.* FROM cars c WHERE c.id NOT IN (SELECT r.car FROM rents r where DATE(date) = '${date}')`, function (error, results, fields) {
        if (error) throw error;
        return res.json({ error: false, data: results });
    });
});

app.post(URLs.AVAILABILITY_FOR_DATE.url, function (req, res) {
    let rent = req.body;

    if (!rent) {
        return res.status(400).send({ error:true, message: 'Please provide rent data' });
    }

    console.log("Spouštím hledání data");
    mc.query("select exists(select * from rents where car = ? and date = DATE(?) and active = 1) as finish", [rent.car, rent.date], function (error, results, fields) {
        let exit = results[0].finish;
        if (exit !== 0) {
            return res.status(400).send({ error:true, message: 'This car is already reserved for this date, please try another car.' });
        }
        else {
            //example values -> ('2018-12-28', 1, 299.99, 1)
            mc.query("INSERT INTO rents(date, car, price, user, active) VALUES (?, ?, ?, ?, 1);", [rent.date, rent.car, '16.99', rent.user], function (error, results, fields) {
                if (error) throw error;
                let result = results.insertId;
                return res.send({ error: false, affectedId: result, message: 'New reservation has been created successfully.' });
            });
        }
    });
});

app.post(URLs.AVAILABILITY_FOR_DATE_UNLOCK.url, function (req, res) {
    let rent = req.body;

    if (!rent) {
        return res.status(400).send({ error:true, message: 'Please provide rent data' });
    }

    mc.query("update rents set active = 0 where date = date(?) and car = ?", [rent.date, rent.car], function (error, results, fields) {
        if (error) throw error;
        let result = results.insertId;
        return res.send({ error: false, affectedId: result, message: 'Reservation disabled successfully.' });
    });
});

app.post(URLs.OCR_ANALYSIS.url, function (req, res) {
    let ocr = req.body;
    ocr.user = req.user;


    if (Object.keys(req.files).length === 0) {
        return res.status(400).send({"erorr": true, "message": "No files uploaded"});
    }


    let dir = path.resolve(`./files/${req.user.id}`);
    logger.info(`Saving user ocr data to location=./files/${req.user.id}`, req.loggingOptions);
    // With a callback:
    fs.ensureDir(dir, err => {

        //TODO:// add creating folder for specific user to store his id and driving licence file and encrypt it afterwards
        req.files["id-front"].mv(path.resolve(`${dir}/front.ocr`), (err) => {
            if (err) throw Error("Error with moving uploaded file front");

            req.files["id-back"].mv(path.resolve(`${dir}/back.ocr`), (err) => {
                if (err) throw Error("Error with moving uploaded file back");

                req.files["additional"].mv(path.resolve(`${dir}/driving.ocr`), (err) => {
                    if (err) throw Error("Error with moving uploaded file additional");

                    ocr.id_front = path.resolve(`${dir}/front.ocr`);
                    ocr.id_back = path.resolve(`${dir}/back.ocr`);
                    ocr.additional = path.resolve(`${dir}/driving.ocr`);

                    ocrServiceRequester.send({ type: 'ocr-submit', "ocrData": ocr }, (time) => {
                        return res.send({ error: false, message: time });
                    });

                });
            });
        });

    });

});


app.get(URLs.AUTHENTICATE_TOKEN.url, function (req, res) {
    let sign = tokenizer.sign({"client_id": 10}, {
        issuer: "Authorizaxtion/REZERVATOR/API.JS",
        subject: "iam@user.me",
        audience: "Client_Identity" // this should be provided by client
    });
    console.log(sign);
    let verify = tokenizer.verify(sign, {
        issuer: "Authorizaxtion/REZERVATOR/API.JS",
        subject: "iam@user.me",
        audience: "Client_Identity" // this should be provided by client
    });
    console.log(verify);
    res.json({"error": false, "description": "done"});
});

/*
    {
        "displayName",
        "email",
        "photoUrl",
        "provider",
        "uid"
    }
*/
app.post(URLs.AUTHENTICATE.url, function (req, res) {
    let user = req.body;

    logger.info(`Trying to log-in with user=${user}`, req.loggingOptions);

    if (!user) {
        return res.status(400).send({ error:true, message: 'Please provide user data' });
    }
    if (user.id === null || user.id === '' || user.id === 'null' || user.id === undefined) {
        //TODO check user authId from incoming user object against FirebaseAdmin

        mc.query("select * from users where email = ? and uid = ?", [user.email, user.uid], function (error, results, fields) {
            if (error) throw error;
            let result = results.length;

            if (result) {
                logger.info(`userId=${results[0].id} exists sending tokan`, req.loggingOptions);

                let token = tokenizer.sign(user, {
                    issuer: "Authorizaxtion/REZERVATOR/API.JS",
                    subject: results[0].email,
                    audience: results[0].scope // this should be provided by client
                });
                mc.query("INSERT INTO `rezervator`.`token`(`user`, `token`, `device_id`) VALUES (?, ?, ?);",
                    [results[0].id, token, req.body.device_id], function (error) {
                        if (error) throw error;
                        let cookieOptions = {
                            maxAge: 1000 * 60 * 60 * 24 * 7, // would expire after 7 days
                            httpOnly: true, // The cookie only accessible by the web server
                            signed: true // Indicates if the cookie should be signed
                        };
                        res.cookie('auth', token);
                        res.cookie('id', results[0].id);
                        return res.send({ error: false, created: false, affectedId: results[0].id, user: results[0], token: token});
                });
            }
            else {
                logger.info(`User registration for user=${user} sending token`, req.loggingOptions);
                mc.query("INSERT INTO users(displayName, email, photoUrl, provider, uid) VALUES (?, ?, ?, ?, ?);",
                    [user.displayName, user.email, user.photoUrl, user.provider, user.uid], function (error, results, fields) {
                        if (error) throw error;
                        let result = results.insertId;
                        user.id = results.insertId;
                        let token = tokenizer.sign(user, {
                            issuer: "Authorizaxtion/REZERVATOR/API.JS",
                            subject: user.email,
                            audience: user.scope // this should be provided by client
                        });
                        mc.query("INSERT INTO `rezervator`.`token`(`user`, `token`, `device_id`) VALUES (?, ?, ?);",
                            [results[0].id, token, req.body.device_id], function (error) {
                                if (error) throw error;
                                let cookieOptions = {
                                    maxAge: 1000 * 60 * 60 * 24 * 7, // would expire after 7 days
                                    httpOnly: true, // The cookie only accessible by the web server
                                    signed: true // Indicates if the cookie should be signed
                                };
                                res.cookie('auth', token);
                                res.cookie('id', results[0].id);
                                return res.send({ error: false, created: true, affectedId: result, user: user, message: 'User created successfully.', token: token});
                            });
                });
            }
        });
    }
    else {
        logger.info(`User is just refreshing token`, req.loggingOptions);
        return res.send({ error: false, created: false, affectedId: user.id, user: user});
    }
});

app.post(URLs.VOKATIV.url, function (req, res) {
    let name = req.body;
    emailServiceRequester.send({ type: 'email-return-vokativ', "name": name.name, "woman": false, "last": false }, (vokativ) => {
        return res.send({ error: false, vokativ: vokativ });
    });
});

app.get(URLs.TEMPLATE_TEST.url, function (req, res) {
    emailServiceRequester.send({ type: 'email-send-with-template', "template": "registration_done", "user_id": req.user.id}, (html_page) => {
        return res.send(html_page);
    });
});

app.get(URLs.SMS_TEST.url, function (req, res) {
    smsServiceRequester.send({ type: 'sms-send-template', "template": "ocr-done", "user_id": req.user.id}, (json) => {
        return res.send(json);
    });
});

app.get(URLs.RENT_SERVICE_TEST.url, function (req, res) {
    rezervationServiceRequester.send({ type: 'list-cars-from-date-for-time'}, (rents) => {
        res.json(rents);
        console.log("All rents:", JSON.stringify(rents, null, 4));
    });
});




// port must be set to 8080 because incoming http requests are routed from port 80 to port 8080
app.listen(8080, function () {
    console.log('Rezervator is up and running');
});