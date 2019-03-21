const cote = require('cote');
const mysql = require('mysql');
const request = require('request');
const _ = require("lodash");

let prod = false;

const templates = {
    "ocr-done": "Dobrý den ${vokativ},\nVáš účet byl právě schválen, nyní se můžete přihlásit a užít si svou první jízdu.\nVáš REEZ 🚗",
    "activate-code": "Dobrý den,\n Váš REEZ aktivační kód je: ${code}"
};

const mc = mysql.createPool({
    connectionLimit : 50,
    host: '127.0.0.1',
    user: 'root',
    password: '25791998',
    database: 'rezervator'
});

const smsService  = new cote.Responder({ name: 'SMS Service', key: 'sms', });

let optionsSmsApi = {
    method: 'POST',
    url: 'https://api.smsapi.com/sms.do',
    headers:
        {
            Authorization: 'Bearer vhbMbet5c9nbZldT20o7yluWMKh2cUoKyxgC9Klh',
            'Content-Type': 'application/x-www-form-urlencoded'
        },
    form: null
};

let sendMessage = (phone, message) => {

    optionsSmsApi.form = {
        from: 'REEZ',
        to: phone,
        message: message,
        format: 'json',
    };

    request(optionsSmsApi, function (error, response, body) {
        if (error) throw new Error(error);
        console.log(body);
    });
};

let sendTemplate = (user, template, callback) => {

    mc.query("SELECT * FROM users u INNER JOIN userDetail ud on u.id = ud.user_id INNER JOIN documentData dd on ud.document_data = dd.id WHERE u.id = ? order by ud.id desc limit 1;", [user], function (error, resultsUser, fields) {
        console.log(error);
        console.log(resultsUser);
        let user = resultsUser[0];
        let compile = _.template(templates[template]);
        console.log(user.vokativ);
        let compiled = compile({"vokativ": user.vokativ});
        console.log(compiled);

        optionsSmsApi.form = {
            from: 'REEZ',
            to: user.phone_number,
            message: compiled,
            format: 'json',
        };
        callback(optionsSmsApi);

        if (prod) {
            request(optionsSmsApi, function (error, response, body) {
                if (error) throw new Error(error);
                console.log(body);
                callback(JSON.parse(body));
            });
        }
        else {
            callback({"error": true, "mock": true, "desc":"not running on prod, sms not send"});
        }

    });
};



smsService.on('sms-send-message', (req, cb) => {
    sendMessage(req.phone, req.message);
    cb({"error": false, "desc": "sms sent"});
});

smsService.on('sms-send-template', (req, cb) => {
    sendTemplate(req.user_id, req.template, cb);
});


