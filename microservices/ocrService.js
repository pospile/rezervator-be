const cote = require('cote');
const fs = require('fs');
const got = require('got');
const FormData = require('form-data');
let request = require('request');
const Cookie = require('request-cookies').Cookie;
const {CookieJar} = require('tough-cookie');
const cookieJar = new CookieJar();


request = request.defaults({jar: true});
let ocrService;
let dbServiceRequester;
let emailServiceRequester;
let smsServiceRequester;

let authorizationCookie;


let loginToOcrService = () => {
    let url = "https://zonky.blindspot.ai/login";
    request({
        url: url,
        method: "POST",
        json: {"username": "zonky", "password": "zonky123"}
    }, function (err, response, body) {
        if (err) throw Error("ocrService was not able to contact ocr service");

        let rawcookies = response.headers['set-cookie'];
        let cookie = new Cookie(rawcookies[0]);
        authorizationCookie = cookie.value;
        console.log("Successfull login in to OCR service");
        bootUpOcrService();
    });
};

let uploadFilesToRecognize = (user, id_front_url, id_back_url, additional_url) => {
    try {
        let url = "https://zonky.blindspot.ai/api/upload";

        console.log("Upload started");

        cookieJar.setCookie(`Authorization=${authorizationCookie}`, 'https://zonky.blindspot.ai', {}, function () {
            (async () => {
                try {

                    const form = new FormData({});

                    form.append('id-front', fs.createReadStream(`${id_front_url}`));
                    form.append('id-back', fs.createReadStream(`${id_back_url}`));
                    form.append('additional', fs.createReadStream(`${additional_url}`));

                    try {
                        const response = await got.post(url, {
                            body: form,
                            cookieJar: cookieJar
                        });

                        console.log("Upload successfully finished");
                        console.log(response.body);

                        dbServiceRequester.send({ type: 'db-save-ocr-code', "code": response.body, "user": user.id }, (row_id) => {

                            let req = {"code": response.body};
                            poolDownload(req, function (ocr_response) {

                                dbServiceRequester.send({ type: 'db-save-downloaded-ocr', "json": ocr_response, "insertedId": row_id, "user": user.id }, (idVerify) => {

                                    console.log(JSON.parse(ocr_response));
                                    console.log("Ocr analysis finished and saved to db");
                                    emailServiceRequester.send({ type: 'email-return-vokativ', "inner": true, "id": idVerify, "name": JSON.parse(ocr_response).result.name, "woman": false, "last": false }, () => {});
                                    dbServiceRequester.send({ type: 'db-calculate-confidence', "user": user }, () => {});
                                    setTimeout(() => {
                                        emailServiceRequester.send({ type: 'email-send-with-template', "template": "registration_done", "user_id": user.id}, () => {});
                                        smsServiceRequester.send({ type: 'sms-send-template', "template": "ocr-done", "user_id": user.id}, () => {});
                                    }, 1000);
                                });

                            });

                        });
                    }
                    catch (e) {
                        console.log(e);
                        uploadFilesToRecognize(user, id_front_url, id_back_url, additional_url);
                    }
                } catch (error) {
                    console.log(error);
                    uploadFilesToRecognize(user, id_front_url, id_back_url, additional_url);
                }
            })();
        });
    }
    catch (e) {
        console.log(error);
        uploadFilesToRecognize(user, id_front_url, id_back_url, additional_url);
    }
};

let downloadOcrAnalysis = (req, cb) => {
    console.log(`Spouštím loading ocr pro ${req.code}`);
    let url = `https://zonky.blindspot.ai/api/result?id=${req.code}`;

    cookieJar.setCookie(`Authorization=${authorizationCookie}`, 'https://zonky.blindspot.ai', {}, function () {
        (async () => {
            try {


                const response = await got.get(url, {
                    cookieJar: cookieJar
                });
                console.log("Analysis downloaded");

                let responseJson = JSON.parse(response.body);

                if (responseJson.type === "success")
                {
                    console.log("Ocr analysis success");
                    console.log(responseJson);
                    cb(true, response.body);
                }
                else
                {
                    console.log("error when downloading ocr analysis");
                    console.log(responseJson);
                    cb(false);
                }

            } catch (error) {
                console.log(error);
            }
        })();
    });
};


let poolDownload = (req, cb) => {
    downloadOcrAnalysis(req, function (done, data) {
        if (done) {
            cb(data);
        }
        else {
            setTimeout(function(){
                poolDownload(req, cb);
            }, 3000);
        }
    });
};

let bootUpOcrService = () => {
    ocrService = new cote.Responder({ name: 'Ocr Service', key: 'ocr', });
    dbServiceRequester = new cote.Requester({ name: 'dbServiceRequester', key: 'db', });
    emailServiceRequester = new cote.Requester({ name: 'emailServiceRequester', key: 'email'});
    smsServiceRequester = new cote.Requester({ name: 'sms service requester', key: 'sms'});
    ocrService.on('ocr-submit', (req, cb) => {
        let user = req.ocrData.user;
        console.log(req);
        uploadFilesToRecognize(user, req.ocrData.id_front, req.ocrData.id_back, req.ocrData.additional);
        cb({"erorr": false, "message": 'Ocr analysis started, we will notify you when its done.'});
    });
};



loginToOcrService();


