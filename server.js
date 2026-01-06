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
        res.end(`
            <html>
            <head><title>Fractal Battle Video</title></head>
            <body>
                <h1>Fractal Battle: Babies Mandelbrot vs Julia Sets</h1>
                <p>Watch the AI-driven battle between mathematical fractals!</p>
                <video controls width="800" height="400">
                    <source src="/battle.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
                <p>Generated with Julia, served with Node.js.</p>
            </body>
            </html>
        `);
    }
});

server.listen(3000, () => {
    console.log('Node.js server running at http://localhost:3000');
    console.log('Open in browser to watch the fractal battle video!');
});