const mysql = require('mysql');
const fs = require('fs');
const appRoot = require('app-root-path');
const mysql_import = require('mysql-import');

let mc = mysql.createPool({
    connectionLimit : 50,
    host: 'mysql',
    user: 'root',
    password: '25791998',
    database: 'rezervator'
});

var walkSync = function(dir, filelist) {
    var fs = fs || require('fs'),
        files = fs.readdirSync(dir);
    filelist = filelist || [];
    files.forEach(function(file) {
        if (fs.statSync(dir + '/' + file).isDirectory()) {
            filelist = walkSync(dir + '/' + file, filelist);
        }
        else {
            filelist.push(file);
        }
    });
    return filelist;
};

console.log(`Running db migration tool for rezervator`);

mc.query('select now() as time', [], function (err, data, val) {

    if (err) throw err;

    console.log(`Rezervator migration tool succesfully connected to db, starting migrations...`);

    let rootPath = `${appRoot}/migration`;

    let fileList;
    fileList = walkSync(rootPath, fileList);

    fileList.forEach((value) => {
        console.log(`Running db migration ${value}`);

        var importer = mysql_import.config({
            host: process.env.MYSQL_HOST,
            user: 'root',
            password: process.env.MYSQL_PASS,
            database: 'rezervator',
            onerror: err=>console.log(err.message)
        });

        importer.import(`${rootPath}/${value}`).then(()=> {
            console.log(`Finished importing --> ${value}`);
            mc.query(`INSERT INTO migrations(migration, finish) VALUES (?, now());`, [value], function (err, data, val) {
                if (err) throw err;
                console.log(`Finished saving of db migration --> ${value}`);
            });
        });

    });

});

