#!/usr/bin/env node

var jsdom = require("jsdom"),
    http = require("http"),
    path = require("path"),
    fs = require("fs");

var fileCount = 0, 
    //subreddit = 'wallpaper+wallpapers',
    subreddit = 'christmasporn+winterporn',
    // subreddit = 'wallpaper+wallpapers+earthporn',
    //subreddit = 'earthporn+villageporn+cityporn+spaceporn+waterporn+abandonedporn+animalporn+humanporn+botanicalporn+adrenalineporn+destructionporn+movieposterporn+albumartporn+machineporn+newsporn+geekporn+bookporn+mapporn+adporn+designporn+roomporn+militaryporn+historyporn+quotesporn+skyporn+fireporn+infrastructureporn',
    targetDir = '/home/johannes/cbi/desktop-artwork/wallpapers/Christmas/reddit';

jsdom.env(
    "http://www.reddit.com/r/" + subreddit,
    ["http://code.jquery.com/jquery.js"],
    function (errors, window) {
        var $ = window.$;
        $("a.title").each(function(){
            var href = $(this).attr('href');
            if( href.match(/^http:.*\.(png|jpe?g|gif)$/i) ) {
                var fileName = (100+fileCount++) + path.basename(href);
                fileName = fileName.substr(1);
                saveImage(href, fileName);
            }
        });
    }
);

function saveImage(url, fileName) {
    console.log("writing",url,"to",targetDir+'/'+fileName);
    var request = http.get(url, function(res){
        var imagedata = ''
        res.setEncoding('binary')

        res.on('data', function(chunk){
            imagedata += chunk
        })

        res.on('end', function(){
            fs.writeFile(targetDir+'/'+fileName, imagedata, 'binary', function(err){
                if (err) throw err
            })
        })

    });
}
