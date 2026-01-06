const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
    if (req.url === '/battle.mp4') {
        const filePath = path.join(__dirname, 'battle.mp4');
        fs.stat(filePath, (err, stats) => {
            if (err) {
                res.writeHead(404);
                res.end('File not found');
                return;
            }
            res.writeHead(200, {
                'Content-Type': 'video/mp4',
                'Content-Length': stats.size
            });
            const stream = fs.createReadStream(filePath);
            stream.pipe(res);
        });
    } else {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end(fs.readFileSync('snake.html', 'utf8'));
    }
});

server.listen(3000, () => {
    console.log('Node.js server running at http://localhost:3000');
    console.log('Open in browser to watch the fractal battle video!');
});