const cote = require('cote');
const mysql = require('mysql');
const { vokativ, isWoman } = require('vokativ');
const _ = require("lodash");
const nodemailer = require("nodemailer");

let prod = true;

const mc = mysql.createPool({
    connectionLimit : 50,
    host: 'mysql',
    user: 'root',
    password: '25791998',
    database: 'rezervator'
});

const emailService  = new cote.Responder({ name: 'Email Service', key: 'email', });

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

emailService.on('email-return-vokativ', (req, cb) => {
    let vok = capitalizeFirstLetter(vokativ(req.name, req.woman, req.last));
    if (req.inner) {
        mc.query("UPDATE userDetail SET vokativ = ? WHERE id = ?;", [vok, req.id], function (error, results, fields) {
            console.log(`ukládám vokativ uživatele ${req.id}`);
            cb(vok);
        });
    }
    else
    {
        cb(vok);
    }
});

emailService.on('email-send-with-template', (req, cb) => {

    mc.query("SELECT * FROM users u INNER JOIN userDetail ud on u.id = ud.user_id INNER JOIN documentData dd on ud.document_data = dd.id WHERE u.id = ? order by ud.id desc limit 1;", [req.user_id], function (error, resultsUser, fields) {
        mc.query("select * from emailTemplate where name = ? order by version desc limit 1;", [req.template], function (error, results, fields) {
            let user = resultsUser[0];
            let compile = _.template(results[0].code);
            console.log(user.vokativ);
            let compiled = compile({"vokativ": user.vokativ});
            //console.log(compiled);

            /*
            let account = nodemailer.createTestAccount();

            // create reusable transporter object using the default SMTP transport
            let transporter = nodemailer.createTransport({
                host: "smtp.ethereal.email",
                port: 587,
                secure: false, // true for 465, false for other ports
                auth: {
                    user: account.user, // generated ethereal user
                    pass: account.pass // generated ethereal password
                }
            });

            // setup email data with unicode symbols
            let mailOptions = {
                from: 'info@reez.cz', // sender address
                to: `${user.email}`, // list of receivers
                subject: `${user.vokativ} Váš účet byl schválen!`, // Subject line
                html: compiled // html body
            };

            // send mail with defined transport object
            let info = transporter.sendMail(mailOptions);

            console.log("Message sent: %s", info.messageId);
            // Preview only available when sending through an Ethereal account
            console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
            */

            nodemailer.createTestAccount((err, account) => {
                // create reusable transporter object using the default SMTP transport
                let transporter;
                if (prod) {
                    //smtp-167478.m78.wedos.net
                    transporter = nodemailer.createTransport({
                        host: 'smtp-167478.m78.wedos.net',
                        port: 465,
                        secure: true, // true for 465, false for other ports
                        auth: {
                            user: 'admin@underholding.cz', // generated ethereal user
                            pass: 'Siemens2579!'  // generated ethereal password
                        }
                    });
                }
                else {
                    transporter = nodemailer.createTransport({
                        host: 'smtp.ethereal.email',
                        port: 587,
                        secure: false, // true for 465, false for other ports
                        auth: {
                            user: account.user, // generated ethereal user
                            pass: account.pass  // generated ethereal password
                        }
                    });
                }


                // setup email data with unicode symbols
                let mailOptions = {
                    from: 'admin@underholding.cz', // sender address
                    to: `${user.email}`, // list of receivers
                    subject: `${user.vokativ} Váš účet byl schválen!`, // Subject line
                    html: compiled // html body
                };

                // send mail with defined transport object
                transporter.sendMail(mailOptions, function(error, info){
                    if(error){
                        return console.log(error);
                    }
                    console.log('Message sent: ' + info.response);
                    console.log(nodemailer.getTestMessageUrl(info));
                });

                cb(compiled);
            });
        });
    });

});