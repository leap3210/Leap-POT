var express = require('express');
var app = express();
app.use(express.json())
var fs = require("fs");

//js receives username + watchtime + host_id add to checkThese_users
app.post('/addUser', function (req, res) {
    console.log("add user ", req.body)
    let rawdata = fs.readFileSync('checkVerify_users.json');
    let verifiedUsers = JSON.parse(rawdata);

    console.log(typeof(verifiedUsers));
    
    let watchedUsers = req.body;
    console.log(watchedUsers);
    let verifiedWatchedUsers = [];

    watchedUsers.forEach((watchedUser) => {
        if (verifiedUsers.find((verifiedUser) => verifiedUser == watchedUser.name)) {
            verifiedWatchedUsers.push(watchedUser);
        }
    })

    console.log("these users are verified " + verifiedWatchedUsers);

    // read earned users
    // strip out the earneduser.wallet
    // compare earned and find the watched user. If they already watched then take the value from earned user and update. Other wise add to earned user
    // Write earned users back to earned users file (overwrite)

})
