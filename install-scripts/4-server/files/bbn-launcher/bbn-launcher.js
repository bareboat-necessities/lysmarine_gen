/*
 Copyright 2024, Bareboat Necessities
 */
const {commands1} = require('./constants');

const http = require('http');
const url = require('url');
const fileSystem = require('fs');
const path = require('path');

const hostname = '0.0.0.0';
const port = 80;

function writeSvgResponse(res, status, contentType, parsed) {
    const imgName = parsed.query['name'];
    if (imgName && imgName.match(/^[0-9a-zA-Z_\-]+$/)) {
        const filePath = path.join(__dirname, 'img/' + imgName + '.svg');
        const stat = fileSystem.statSync(filePath);
        res.writeHead(status, {
            'Content-Type': contentType,
            'Content-Length': stat.size
        });
        const readStream = fileSystem.createReadStream(filePath);
        readStream.pipe(res);
    }
}

const server = http.createServer((req, res) => {
    //console.log(`req: ${req.url}`);
    const parsed = url.parse(req.url, true);
    //console.log(`path: ${parsed.pathname}`)
    if (parsed.pathname === '/img') {
        writeSvgResponse(res, 200, 'image/svg+xml', parsed, processMain(parsed.query['m']));
    } else {
        writeResponse(res,200, 'text/html', processMain(parsed.query['m']));
    }
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});

function writeResponse(res, status, contentType, content) {
    res.writeHead(200, {
        'Content-Type': contentType,
        'Content-Length': content.length,
        'Expires': new Date().toUTCString()
    }).end(content);
}

const style =
    '\n' +
    '* {\n' +
    '    -webkit-user-select: none;\n' +
    '}\n' +
    'html {\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    'body {\n' +
    '    margin-top: 50px;\n' +
    '    margin-left: 0;\n' +
    '    margin-right: 0;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    'a {\n' +
    '    color:orange;\n' +
    '    text-decoration:none;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    'a:hover, a:focus {\n' +
    '    text-decoration:underline;\n' +
    '}\n' +
    '\n' +
    '.desktop {\n' +
    '    background: #101010;\n' +
    '    margin: 0 auto;\n' +
    '    padding: 6px;\n' +
    '    position: relative;\n' +
    '}\n' +
    '\n' +
    '.tile {\n' +
    '    width: 192px;\n' +
    '    margin: 10px;\n' +
    '    padding: 10px;\n' +
    '    color: White;\n' +
    '    display: inline-block;\n' +
    '    text-align: center;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '    font-size: 15pt;\n' +
    '}\n' +
    '\n' +
    'img {\n' +
    '    -webkit-user-drag: none;\n' +
    '}\n' +
    '.tile-img2 {\n' +
    '    border-radius: 14px;\n' +
    '    width: 65px;\n' +
    '    height: 65px;\n' +
    '    margin: 0 auto;\n' +
    '    padding: 8px;\n' +
    '    text-align: center;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.tile-img {\n' +
    '    width: 65px;\n' +
    '    height: 65px;\n' +
    '    margin: 0 auto;\n' +
    '    padding: 8px;\n' +
    '    text-align: center;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.tile-label {\n' +
    '    padding: 4px;\n' +
    '    text-align: center;\n' +
    '}\n' +
    '\n' +
    '.main-icon {\n' +
    '    max-width: 100%;\n' +
    '    max-height: 100%;\n' +
    '}\n' +
    '\n' +
    '.toolbar {\n' +
    '    margin: 0 6px 2px 0;\n' +
    '    color: White;\n' +
    '    height: 32px;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.button-bar {\n' +
    '    margin: 0 10px 10px 0;\n' +
    '    color: White;\n' +
    '    height: 32px;\n' +
    '    font-family: Sans, Arial, Helvetica, sans-serif;\n' +
    '}\n' +
    '\n' +
    '.main-panel {\n' +
    '    margin: auto;\n' +
    '    width: 720px;\n' +
    '}\n' +
    '\n' +
    '.credits {\n' +
    '    position: absolute;\n' +
    '    bottom: 2px;\n' +
    '}\n' +
    '\n' +
    '.button-bar span {\n' +
    '    border-radius: 4px;\n' +
    '}\n' +
    '\n';

const script = '\n' +
    '    <script>\n' +
    'function showPanel(doFocus, id, link) {\n' +
    '    const w = window.open(link, id);\n' +
    '    if (doFocus) {\n' +
    '        w.focus();\n' +
    '    }\n' +
    '}\n' +
    '    </script>\n';

function getCredits(mode) {
    let nextMode = "BW";
    if ("BW" === mode) {
        nextMode = "Dark";
    } else if ("Dark" === mode) {
        nextMode = "";
    }
    return '    <div class="credits" style="width: 780px;">\n' +
        '        <div style="float: left; color: white;"><a style="text-decoration: none;" href="?m=' + nextMode + '">&#9728; &#9788; &#9789;</a></div>\n' +
        '        <div style="float: right; color: white;">Icons by ' +
        '<span style="color:orange;">Freepik</span> from <span style="color:orange;">www.flaticon.com</span></div>\n' +
        '        <div style="clear:both;"></div>\n' +
        '    </div>';
}

function buildTiles(commands, mode, host) {
    let items = '';
    let suffix = ("Dark" === mode) ? '' : '2';
    commands.forEach(value => {
        let bg = ("Dark" === mode) ? '' : ' style="background: ' + value.bg + ';"';
        let color = ("Dark" === mode) ? ' style="color: #e00d0d;"' : '';
        items = items + '\n' +
            '            <div class="tile">\n' +
            '                <div class="tile-img'+ suffix + '"' + bg + ' onclick="showPanel(true, \'' + value.name + '\', \'http://' + host + value.link + '\');"><img src="img?name=' + value.img + suffix + '" alt="' + value.title + '" class="main-icon"/></div>\n' +
            '                <div class="tile-label" ' + color + '>' + value.title + '</div>\n' +
            '            </div>'
    });
    return items;
}

function getStyle(mode) {
    let css;
    if ("BW" === mode) {
        css = 'html {\n' +
            '    -moz-filter: grayscale(100%);\n' +
            '    -webkit-filter: grayscale(100%);\n' +
            '    filter: gray; /* IE6-9 */\n' +
            '    filter: grayscale(100%);\n' +
            '}\n' + style;
    } else {
        css = style;
    }
    return '    <style>\n' + css +  '    </style>';
}

function processMain(mode) {
    const header = '<head>\n<meta charset="UTF-8">\n' + script + getStyle(mode) +
        '\n    <title>bbn-launcher</title>\n' +
        '\n</head>\n';
    const items1 = buildTiles(commands1, mode, 'coremp135');
    const panel1 =
        '        <div id="panel1" class="main-panel" style="float: left;">' + items1 + '\n' +
        '        </div>\n';

    const panel =
        '    <div>\n' + panel1 +
        '    </div>\n' + getCredits(mode);
    const body = '<body style="background: #0C0C0C;">\n' +
        '<div style="width: 780px; height: 360px;" class="desktop">\n' + panel + '\n</div>\n</body>';
    return '<!DOCTYPE html>\n'
        + '<html lang="en">\n' + header + body + '\n</html>';
}

